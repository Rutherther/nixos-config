import time
import subprocess
from libqtile.lazy import lazy
from libqtile.config import Click, Drag, Group, KeyChord, EzKey, EzKeyChord, Match, Screen, ScratchPad, DropDown, Key
import screeninfo
import utils
import bars
from functions import focus_window_by_class, warp_cursor_to_focused_window, go_to_screen, go_to_group
from nixenvironment import nixConfig
from libqtile.log_utils import logger

def init_screens():
    wallpaper = nixConfig.wallpaper

    screens_info = screeninfo.get_monitors()
    screens_count = len(screens_info)
    screens = [None] * screens_count

    for i in range(0, screens_count):
        screen_info = screens_info[i]
        systray = False
        if screens_count <= 2 and i == 0:
            systray = True
        elif i == 1:
            systray  = True

        top_bar = bars.create_top_bar(systray = systray)

        screens[i] = Screen(top=top_bar, bottom=bars.create_bottom_bar(), wallpaper=wallpaper, width=screen_info.width, height=screen_info.height)

    return screens

def get_screen_physical_order():
    screens = enumerate(screeninfo.get_monitors())
    s = sorted(screens, key = lambda x: (x[1].y, x[1].x))
    return map(lambda x: x[0], s)

def init_navigation_keys(keys, screens):
    order = list(get_screen_physical_order())

    # TODO: how to specify this better?
    # Could be based on the fingerprint for example
    monitor_navigation_keys = ['r', 'w', 'e', 'q']
    for i, key in enumerate(monitor_navigation_keys):
        if i >= len(order):
            break

        keys.extend([
            EzKey(f'M-{key}', go_to_screen(order[i]), desc = f'Move focus to screen {i}'),
            EzKey(f'M-S-{key}', lazy.window.toscreen(order[i]), desc = f'Move window to screen {i}'),
        ])

# Monitors changing connected displays and the lid.
# Calls autorandr to change the outputs, and QTile
# restart
async def observe_monitors():
    from pydbus import SystemBus
    from gi.repository import GLib
    from libqtile.utils import add_signal_receiver
    from dbus_next.message import Message
    import pyudev

    @utils.debounce(0.2)
    def call_autorandr():
        # Autorandr restarts QTile automatically
        subprocess.call(['autorandr', '--change', '--default', 'horizontal'])
        # time.sleep(0.3)
        # subprocess.call(['qtile', 'cmd-obj', '-o', 'cmd', '-f', 'restart'])

    def on_upower_event(message: Message):
        args = message.body
        properties = args[1]
        logger.info(message.body)
        if 'LidIsClosed' in properties:
            call_autorandr()

    def on_drm_event(action=None, device=None):
        if action == "change":
            call_autorandr()

    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by(subsystem = 'drm')
    monitor.enable_receiving()

    logger.warning("Adding signal receiver")
    subscribe = await add_signal_receiver(
        on_upower_event,
        session_bus = False,
        signal_name = "PropertiesChanged",
        path = '/org/freedesktop/UPower',
        dbus_interface = 'org.freedesktop.DBus.Properties',
    )
    logger.warning(f"Add signal receiver: {subscribe}")

    observer = pyudev.MonitorObserver(monitor, on_drm_event)
    observer.start()
