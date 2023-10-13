import re
import os
import subprocess
import psutil
from libqtile import layout, bar, qtile
from libqtile.backend.base import Window
from libqtile.core.manager import Qtile
from libqtile.config import Click, Drag, Group, KeyChord, EzKey, EzKeyChord, Match, Screen, ScratchPad, DropDown, Key
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from libqtile.log_utils import logger
from libqtile.backend.wayland import InputConfig
import qtile_extras.widget as widget
from qtile_extras.widget.decorations import BorderDecoration, PowerLineDecoration, RectDecoration
from tasklist import TaskList
from mpris2widget import Mpris2
from bluetooth import Bluetooth
import xmonadcustom
from nixenvironment import setupLocation, configLocation, sequenceDetectorExec

colors = {
    'primary': '51afef',
    'active': '8babf0',
    'inactive': '555e60',
    'secondary': '55eddc',
    'background_primary': '222223',
    'background_secondary': '444444',
    'urgent': 'c45500',
    'white': 'd5d5d5',
    'grey': '737373',
    'black': '121212',
}

# #####################################
# Utility functions
@lazy.function
def focus_window_by_class(qtile: Qtile, wmclass: str):
    match = Match(wm_class=wmclass)
    windows = [w for w in qtile.windows_map.values() if isinstance(w, Window) and match.compare(w)]
    if len(windows) == 0:
        return

    window = windows[0]
    group = window.group
    group.toscreen()
    group.focus(window)

@lazy.function
def go_to_group(qtile: Qtile, group_name: str, switch_monitor: bool = False):
    found = False
    current_group = qtile.current_group
    if group_name == current_group.name:
        return

    if switch_monitor:
        for screen in qtile.screens:
            if screen.group.name == group_name:
                qtile.focus_screen(screen.index)
                found = True
                break

    qtile.groups_map[group_name].toscreen()

    for window in current_group.windows:
        if window.fullscreen:
            window.toggle_fullscreen()

    if not switch_monitor or not found:
        window: Window
        for window in qtile.groups_map[group_name].windows:
            if window.fullscreen:
                window.toggle_fullscreen()

# expands list of keys with the rest of regular keys,
# mainly usable for KeyChords, where you want any other key
# to exit the key chord instead.
def expand_with_rest_keys(keys: list[EzKey], global_prefix: str) -> list[EzKey]:
    all_keys = ['<semicolon>', '<return>', '<space>'] + [chr(c) for c in range(ord('a'), ord('z') + 1)]
    prefixes = ['', 'M-', 'M-S-', 'M-C-', 'C-', 'S-']

    for prefix in prefixes:
        for potentially_add_key in all_keys:
            potentially_add_key = prefix + potentially_add_key
            if potentially_add_key == global_prefix:
                continue

            found = False
            for existing_key in keys:
                if existing_key.key.lower() == potentially_add_key:
                    found = True
                    break

            if not found:
                keys.append(EzKey(potentially_add_key, lazy.spawn(f'notify-send "Not registered key {global_prefix} {potentially_add_key}"')))

    return keys


# #####################################
# Environment
mod = 'mod4'
terminal = 'alacritty'

layout_theme = {
    'border_focus': colors['active'],
    'border_normal': colors['inactive'],
    'border_width': 1,
    'margin': 3,
}

layouts = [
    xmonadcustom.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    xmonadcustom.MonadWide(**layout_theme),
]

widget_defaults = dict(
    font = 'Roboto Bold',
    fontsize = 13,
    padding = 3,
    background = colors['background_primary'],
    foreground = colors['white'],
)
extension_defaults = widget_defaults.copy()

powerline = {
    'decorations': [
        PowerLineDecoration(path = 'forward_slash')
    ]
}

def create_top_bar(systray = False):
    widgets = [
        widget.Sep(padding = 5, size_percent = 0, background = colors['background_secondary']),
        widget.CurrentScreen(
            active_text = 'I',
            active_color = colors['active'],
            padding = 3,
            fontsize = 16,
            background = colors['background_secondary'],
        ),
        widget.GroupBox(
            markup = False,
            highlight_method = 'line',
            rounded = False,
            margin_x = 2,
            disable_drag = True,
            use_mouse_wheel = True,
            active = colors['white'],
            inactive = colors['grey'],
            urgent_alert_method = 'line',
            urgent_border = colors['urgent'],
            this_current_screen_border = colors['active'],
            this_screen_border = colors['secondary'],
            other_screen_border = colors['inactive'],
            other_current_screen_border = '6989c0',
            background = colors['background_secondary'],
        ),
        widget.CurrentScreen(
            active_text = 'I',
            active_color = colors['active'],
            padding = 3,
            fontsize = 16,
            background = colors['background_secondary'],
            decorations = [
                PowerLineDecoration(path = 'forward_slash'),
            ],
        ),
        widget.Sep(
            linewidth=2,
            size_percent=0,
            padding=5,
        ),
        widget.Prompt(),
        widget.WindowName(
            foreground = colors['primary'],
            width = bar.CALCULATED,
            padding = 10,
            empty_group_string = 'Desktop',
            max_chars = 160,
            decorations = [
                RectDecoration(
                    colour = colors['black'],
                    radius = 0,
                    padding_y = 4,
                    padding_x = 0,
                    filled = True,
                    clip = True,
                ),
            ],
        ),
        widget.Spacer(),
        widget.Chord(
            padding = 15,
            decorations = [
                RectDecoration(
                    colour = colors['black'],
                    radius = 0,
                    padding_y = 4,
                    padding_x = 6,
                    filled = True,
                    clip = True,
                ),
            ]
        ),
        widget.Net(
            interface = 'enp24s0',
            prefix='M',
            format = '{down:6.2f} {down_suffix:<2}↓↑{up:6.2f} {up_suffix:<2}',
            background = colors['background_secondary'],
            **powerline,
        ),
        widget.Memory(
            format = '{MemFree: .0f}{mm}',
            fmt = '{} free',
            **powerline,
        ),
        widget.CPU(
            format = '{load_percent} %',
            fmt = '   {}',
            background = colors['background_secondary'],
            **powerline,
        ),
        widget.DF(
            update_interval = 60,
            partition = '/',
            #format = '[{p}] {uf}{m} ({r:.0f}%)',
            format = '{uf}{m} free',
            fmt = '   {}',
            visible_on_warn = False,
            **powerline,
        ),
        widget.GenPollText(
            func = lambda: subprocess.check_output(['xkblayout-state', 'print', '%s']).decode('utf-8').upper(),
            fmt = '⌨ {}',
            update_interval = 0.5,
            **powerline,
        ),
        widget.Clock(
            timezone='Europe/Prague',
            foreground = colors['primary'],
            format='%A, %B %d - %H:%M:%S',
            background = colors['background_secondary'],
            **powerline
        ),
        widget.Volume(
            fmt = '🕫  {}',
        ),
        widget.Sep(
            foreground = colors['background_secondary'],
            size_percent = 70,
            linewidth = 3,
        ),
        Bluetooth(
            hci = '/dev_88_C9_E8_49_93_16',
            format_connected = '  {battery} %',
            format_disconnected = '  Disconnected',
            format_unpowered = ''
        ),
    ]

    if systray:
        widgets.append(widget.Sep(
            foreground = colors['background_secondary'],
            size_percent = 70,
            linewidth = 2,
        ))
        widgets.append(widget.Systray())
        widgets.append(widget.Sep(padding = 5, size_percent = 0))

    return bar.Bar(widgets, 30)

def create_bottom_bar():
    return bar.Bar([
        TaskList(
            parse_text = lambda text : re.split(' [–—-] ', text)[-1],
            highlight_method = 'line',
            txt_floating = '🗗 ',
            txt_maximized = '🗖 ',
            txt_minimized = '🗕 ',
            borderwidth = 3,
        ),
        widget.Spacer(),
        Mpris2(
            display_metadata = ['xesam:title'],
            playerfilter = '.*Firefox.*',
            paused_text = '', #'   {track}',
            playing_text = '    {track}',
            padding = 10,
            decorations = [
                RectDecoration(
                    colour = colors['black'],
                    radius = 0,
                    padding_y = 4,
                    padding_x = 5,
                    filled = True,
                    clip = True,
                ),
            ],
        ),
        Mpris2(
            display_metadata = ['xesam:title', 'xesam:artist'],
            objname = 'org.mpris.MediaPlayer2.spotify',
            paused_text = '', #'   {track}',
            playing_text = '  {track}', # '   {track}',
            padding = 10,
            decorations = [
                RectDecoration(
                    colour = colors['black'],
                    radius = 0,
                    padding_y = 4,
                    padding_x = 5,
                    filled = True,
                    clip = True,
                ),
            ],
        ),
        widget.Sep(
            size_percent = 0,
            padding = 5,
            **powerline,
        ),
        widget.Wttr(
            location = {'Odolena_Voda': ''},
            format = '%t %c',
            background = colors['background_secondary'],
            **powerline,
        ),
    ], 30)

def init_screen(top_bar, wallpaper):
    return Screen(top=top_bar, bottom=create_bottom_bar(), wallpaper=wallpaper, width=1920, height=1080)

screens = [
    init_screen(create_top_bar(), f'{setupLocation}/wall.png'),
    init_screen(create_top_bar(systray = True), f'{setupLocation}/wall.png'),
    init_screen(create_top_bar(), f'{setupLocation}/wall.png'),
]

# Keys
keys = []

# up, down, main navigation
keys.extend([
    EzKey('M-j', lazy.layout.down(), desc = 'Move focus down'),
    EzKey('M-k', lazy.layout.up(), desc = 'Move focus up'),
    EzKey('M-S-j', lazy.layout.shuffle_down(), desc = 'Move focus down'),
    EzKey('M-S-k', lazy.layout.shuffle_up(), desc = 'Move focus up'),
    EzKey('M-C-h', lazy.layout.shrink_main(), desc = 'Move focus down'),
    EzKey('M-C-l', lazy.layout.grow_main(), desc = 'Move focus up'),
    EzKey('M-m', lazy.layout.focus_first(), desc = 'Focus main window'),
    EzKey('M-u', lazy.next_urgent(), desc = 'Focus urgent window'),
])

keys.extend([
    EzKey('M-n', lazy.layout.normalize()),
    EzKey('M-t', lazy.window.disable_floating()),
    EzKey('M-f', lazy.window.toggle_fullscreen()),
    EzKey('M-<Return>', lazy.layout.swap_main()),
    EzKey('M-<Space>', lazy.next_layout()),
    EzKey('M-S-<Space>', lazy.to_layout_index(0), desc = 'Default layout'),
    EzKey('M-<comma>', lazy.layout.increase_nmaster()),
    EzKey('M-<period>', lazy.layout.decrease_nmaster()),
])

# Spwning programs
keys.extend([
    EzKey('M-<semicolon>', lazy.spawn('rofi -show drun')),
    EzKey('A-<semicolon>', lazy.spawn('rofi -show windowcd -modi window,windowcd')),
    EzKey('M-S-<semicolon>', lazy.spawn('rofi -show window -modi window,windowcd')),
    EzKey('M-S-<Return>', lazy.spawn(terminal)),
])

keys.extend([
    # social navigation
    EzKeyChord('M-a', expand_with_rest_keys([
       EzKey('b', focus_window_by_class('discord')),
       EzKey('n', focus_window_by_class('Cinny')),
       EzKey('m', focus_window_by_class('Cinny')),

       # notifications
       EzKey('l', lazy.spawn(f'{setupLocation}/scripts/notifications/clear-popups.sh')),
       EzKey('p', lazy.spawn(f'{setupLocation}/scripts/notifications/pause.sh')),
       EzKey('u', lazy.spawn(f'{setupLocation}/scripts/notifications/unpause.sh')),
       EzKey('t', lazy.spawn(f'{setupLocation}/scripts/notifications/show-center.sh')),

       EzKey('e', lazy.spawn('emacsclient -c')),
    ], 'M-a'), name = 'a')
])

keys.extend([
    EzKeyChord('M-s', expand_with_rest_keys([
       EzKey('e', lazy.spawn('emacsclient -c')),
       EzKey('c', lazy.group['scratchpad'].dropdown_toggle('ipcam')),
       EzKey('s', lazy.group['scratchpad'].dropdown_toggle('spotify')),
       EzKey('b', lazy.group['scratchpad'].dropdown_toggle('bluetooth')),
       EzKey('a', lazy.group['scratchpad'].dropdown_toggle('audio')),
       EzKey('m', lazy.group['scratchpad'].dropdown_toggle('mail')),
       EzKey('p', lazy.group['scratchpad'].dropdown_toggle('proton')),
    ], 'M-s'), name = 's')
])

# bars
keys.extend([
    EzKey('M-b', lazy.hide_show_bar('all')),
    EzKey('M-v', lazy.hide_show_bar('bottom')),
])

# media keys
keys.extend([
    EzKey('<XF86AudioPlay>', lazy.spawn(f'{sequenceDetectorExec} -g mpris play')),
    EzKey('<XF86AudioPause>', lazy.spawn(f'{sequenceDetectorExec} -g mpris pause')),
    EzKey('<XF86AudioStop>', lazy.spawn(f'{sequenceDetectorExec} -g mpris stop')),
    EzKey('<XF86AudioNext>', lazy.spawn(f'{sequenceDetectorExec} -g mpris next')),
    EzKey('<XF86AudioPrev>', lazy.spawn(f'{sequenceDetectorExec} -g mpris prev')),
    EzKey('<XF86AudioMute>', lazy.spawn('amixer -D pulse set Master 1+ toggle')),
    EzKey('<XF86MonBrightnessUp>', lazy.spawn(f'{configLocation}/brightness.sh up')),
    EzKey('<XF86MonBrightnessDown>', lazy.spawn(f'{configLocation}/brightness.sh down')),
])

# Printscreen
keys.extend([
    EzKey('<Print>', lazy.spawn('flameshot gui')),
])

# Locking
keys.extend([
    EzKey('M-S-m', lazy.spawn('loginctl lock-session')),
])

# Qtile control
keys.extend([
    EzKey('M-S-c', lazy.window.kill()),
    EzKey('M-C-r', lazy.reload_config()),
    EzKey('M-C-q', lazy.shutdown()),
])

# Monitor navigation
monitor_navigation_keys = ['w', 'e', 'r']
for i, key in enumerate(monitor_navigation_keys):
    monitor_index_map = [ 2, 0, 1 ]
    keys.extend([
        EzKey(f'M-{key}', lazy.to_screen(monitor_index_map[i]), desc = f'Move focus to screen {i}'),
        EzKey(f'M-S-{key}', lazy.window.toscreen(monitor_index_map[i]), desc = f'Move focus to screen {i}'),
    ])

if qtile.core.name == 'x11':
    keys.append(EzKey('M-S-z', lazy.spawn('clipmenu')))
elif qtile.core.name == 'wayland':
    keys.append(
        EzKey(
            'M-S-z',
            lazy.spawn('sh -c "cliphist list | dmenu -l 10 | cliphist decode | wl-copy"')
        )
    )

group_defaults = {
    '9': {
        'layout': 'max'
    }
}
logger.info(group_defaults.get('9'))
groups = [Group(i) if not (i in group_defaults.keys()) else Group(i, **group_defaults.get(i)) for i in '123456789']

for i in groups:
    keys.extend(
        [
            EzKey(
                f'M-{i.name}',
                go_to_group(i.name),
                desc='Switch to group {}'.format(i.name),
            ),
            Key(
                [mod, 'shift'],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc='Switch to & move focused window to group {}'.format(i.name),
            ),
        ]
    )

scratch_pad_middle = {
    'x': 0.2, 'y': 0.2,
    'height': 0.6, 'width': 0.6,
}

groups.append(
    ScratchPad('scratchpad', [
        DropDown(
            'spotify',
            ['spotify'],
            on_focus_lost_hide = True,
            **scratch_pad_middle
        ),
        DropDown(
            'bluetooth',
            ['blueman-manager'],
            on_focus_lost_hide = True,
            **scratch_pad_middle
        ),
        DropDown(
            'audio',
            ['pavucontrol'],
            on_focus_lost_hide = True,
            **scratch_pad_middle
        ),
        DropDown(
            'mail',
            ['thunderbird'],
            on_focus_lost_hide = True,
            x = 0.025, y = 0.025,
            width = 0.95, height = 0.95,
            opacity = 1,
        ),
        DropDown(
            'proton',
            ['firefoxpwa', 'site', 'launch', '01HBD772V37WPQ3B2T7TQJ81PM'],
            match = Match(wm_class = 'FFPWA-01HBD772V37WPQ3B2T7TQJ81PM'),
            on_focus_lost_hide = True,
            x = 0.025, y = 0.025,
            width = 0.95, height = 0.95,
            opacity = 1,
        ),
    ])
)

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
    ]
)
auto_fullscreen = True
focus_on_window_activation = 'urgent'
reconfigure_screens = False
auto_minimize = True
bring_front_click = False

wl_input_rules = {}
wmname = 'LG3D'

# Swallow windows,
# when a process with window spawns
# another process with a window as a child, minimize the first
# winddow. Turn off the minimization after the child process
# is done.
@hook.subscribe.client_new
def _swallow(window):
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
    for i in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            parent.minimized = True
            window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()

@hook.subscribe.client_killed
def _unswallow(window):
    if hasattr(window, 'parent'):
        window.parent.minimized = False

# Startup setup,
# windows to correct workspaces,
# start autostart.sh
@hook.subscribe.startup_once
def autostart():
    subprocess.call([f'{configLocation}/autostart.sh'])

firefoxInstance = 0
@hook.subscribe.client_new
def startup_applications(client: Window):
    global firefoxInstance

    if not isinstance(client, Window):
        return

    if client.match(Match(wm_class = 'firefox')) and firefoxInstance <= 1:
        client.togroup(groups[firefoxInstance].name)
        firefoxInstance += 1
    elif client.match(Match(wm_class = 'discord')) or client.match(Match(wm_class = 'telegram-desktop')) or client.match(Match(wm_class = 'cinny')):
        client.togroup(groups[8].name)

@hook.subscribe.screen_change
@lazy.function
def set_screens(qtile, event):
    if not os.path.exists(os.path.expanduser('~/NO-AUTORANDR')):
        subprocess.run(["autorandr", "--change"])
        qtile.cmd_restart()

# Turn off fullscreen on unfocus
@hook.subscribe.client_focus
def exit_fullscreen_on_focus_changed(client: Window):
    windows = client.group.windows
    window: Window
    for window in windows:
        if window != client and window.fullscreen:
            window.toggle_fullscreen()

# Start scratchpads
@hook.subscribe.startup_complete
def scratchpad_startup():
    scratchpad: ScratchPad = qtile.groups_map['scratchpad']
    for dropdown_name, dropdown_config in scratchpad._dropdownconfig.items():
        scratchpad._spawn(dropdown_config)
        def wrapper(name):
            def hide_dropdown(_):
                dropdown = scratchpad.dropdowns.get(name)
                if dropdown:
                    dropdown.hide()
                    hook.unsubscribe.client_managed(hide_dropdown)
            return hide_dropdown

        hook.subscribe.client_managed(wrapper(dropdown_name))

