# Copyright (c) 2021 Graeme Holliday
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from dbus_next.aio import MessageBus
from dbus_next.constants import BusType

from libqtile.widget import base
from libqtile.log_utils import logger

import asyncio

BLUEZ = "org.bluez"
BLUEZ_PATH = "/org/bluez/hci0"
BLUEZ_ADAPTER = "org.bluez.Adapter1"
BLUEZ_DEVICE = "org.bluez.Device1"
BLUEZ_BATTERY = "org.bluez.Battery1"
BLUEZ_PROPERTIES = "org.freedesktop.DBus.Properties"

def synchronize_async_helper(to_await):
    async_response = []

    async def run_and_capture_result():
        r = await to_await
        async_response.append(r)

    loop = asyncio.get_event_loop()
    coroutine = run_and_capture_result()
    loop.run_until_complete(coroutine)
    return async_response[0]

class Bluetooth(base._TextBox):
    """
    Displays bluetooth status for a particular connected device.

    (For example your bluetooth headphones.)

    Uses dbus-next to communicate with the system bus.

    Widget requirements: dbus-next_.

    .. _dbus-next: https://pypi.org/project/dbus-next/
    """

    defaults = [
        (
            "hci",
            "/dev_XX_XX_XX_XX_XX_XX",
            "hci0 device path, can be found with d-feet or similar dbus explorer.",
        ),
        (
            "format_connected",
            "{name}: {battery}%",
            "format of the string to show"
        ),
        (
            "format_disconnected",
            "not connected",
            "what to show when not connected"
        ),
        (
            "format_unpowered",
            "adapter off",
            "what to show when the adapter is off"
        ),
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, "", **config)
        self._update_battery_task = None
        self.add_defaults(Bluetooth.defaults)

    async def _config_async(self):
        # set initial values
        self.powered = await self._init_adapter()
        self.connected, self.device, self.battery = await self._init_device()
        self.update_text()

    async def _init_adapter(self):
        # set up interface to adapter properties using high-level api
        bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        introspect = await bus.introspect(BLUEZ, BLUEZ_PATH)
        obj = bus.get_proxy_object(BLUEZ, BLUEZ_PATH, introspect)
        iface = obj.get_interface(BLUEZ_ADAPTER)
        props = obj.get_interface(BLUEZ_PROPERTIES)

        powered = await iface.get_powered()
        # subscribe receiver to property changed
        props.on_properties_changed(self._adapter_signal_received)
        return powered

    async def _init_device(self):
        # set up interface to device properties using high-level api
        bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        introspect = await bus.introspect(BLUEZ, BLUEZ_PATH + self.hci)
        obj = bus.get_proxy_object(BLUEZ, BLUEZ_PATH + self.hci, introspect)
        device_iface = obj.get_interface(BLUEZ_DEVICE)
        props = obj.get_interface(BLUEZ_PROPERTIES)

        battery = None
        try:
            battery_iface = obj.get_interface(BLUEZ_BATTERY)
            battery = await battery_iface.get_percentage()
        except:
            pass

        connected = await device_iface.get_connected()
        name = await device_iface.get_name()
        # subscribe receiver to property changed
        props.on_properties_changed(self._device_signal_received)
        return connected, name, battery

    def _adapter_signal_received(
        self, interface_name, changed_properties, _invalidated_properties
    ):
        powered = changed_properties.get("Powered", None)
        if powered is not None:
            self.powered = powered.value
            self.update_text()

    def _device_signal_received(
        self, interface_name, changed_properties, _invalidated_properties
    ):
        connected = changed_properties.get("Connected", None)
        if connected is not None:
            self.connected = connected.value
            self.update_text()
            if self.connected == True:
                self.on_connected()

        device = changed_properties.get("Name", None)
        if device is not None:
            self.device = device.value
            self.update_text()

        battery = changed_properties.get("Percentage", None)
        if battery is not None:
            self.battery = battery.value
            self.update_text()

    def on_connected(self):
        if self._update_battery_task != None:
            self._update_battery_task.cancel()
        self._update_battery_task = self.timeout_add(1, self.update_battery_percentage)

    async def update_battery_percentage(self):
        self._update_battery_task = None
        battery = None
        bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        try:
            introspect = await bus.introspect(BLUEZ, BLUEZ_PATH + self.hci)
            obj = bus.get_proxy_object(BLUEZ, BLUEZ_PATH + self.hci, introspect)
            battery_iface = obj.get_interface(BLUEZ_BATTERY)
            self.battery = await battery_iface.get_percentage()
            bus.disconnect()
            self.update_text()
        except Exception as e:
            logger.warning(e)
            bus.disconnect()

    def update_text(self):
        text = ""
        if not self.powered:
            text = self.format_unpowered
        else:
            if not self.connected:
                text = self.format_disconnected
            else:
                text = self.format_connected.format(battery = self.battery, name = self.device)
        self.update(text)
