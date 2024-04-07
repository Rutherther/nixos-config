import psutil
import libqtile
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
import xmonadcustom
from nixenvironment import nixConfig
import functions
import utils
from screens import init_screens, observe_monitors, init_navigation_keys
from styling import colors
import time

# #####################################
# Environment
mod = 'mod4'
terminal = nixConfig.defaults.terminal

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

screens = init_screens()

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
    EzKey('M-S-m', lazy.window.toggle_minimize()),
    EzKey('M-t', lazy.window.disable_floating()),
    EzKey('M-f', lazy.window.toggle_fullscreen()),
    EzKey('M-S-f', lazy.to_layout_index(1)),
    EzKey('M-<Return>', lazy.layout.swap_main()),
    EzKey('M-<Space>', lazy.next_layout()),
    EzKey('M-S-<Space>', lazy.to_layout_index(0), desc = 'Default layout'),
    EzKey('M-<comma>', lazy.layout.increase_nmaster()),
    EzKey('M-<period>', lazy.layout.decrease_nmaster()),
])

# Spwning programs
keys.extend([
    EzKey('M-<semicolon>', lazy.spawn('rofi -show drun -show-icons')),
    EzKey('A-<semicolon>', lazy.spawn('rofi -show windowcd -modi window,windowcd')),
    EzKey('M-S-<semicolon>', lazy.spawn('rofi -show drun -theme launchpad -show-icons')),
    # EzKey('M-S-<semicolon>', lazy.spawn('rofi -show window -modi window,windowcd')),
    EzKey('M-S-<Return>', lazy.spawn(terminal)),
])

keys.extend([
    # social navigation
    EzKeyChord('M-a', utils.expand_with_other_keys([
       EzKey('b', functions.focus_window_by_class('discord')),
       EzKey('n', functions.focus_window_by_class('element')),
       EzKey('m', functions.focus_window_by_class('element')),

       # notifications
       EzKey('l', lazy.spawn(f'{nixConfig.scripts.notifications.clear_popups}')),
       EzKey('p', lazy.spawn(f'{nixConfig.scripts.notifications.pause}')),
       EzKey('u', lazy.spawn(f'{nixConfig.scripts.notifications.unpause}')),
       EzKey('t', lazy.spawn(f'{nixConfig.scripts.notifications.show_center}')),

       EzKey('e', lazy.spawn('emacsclient -c')),
    ], 'M-a'), name = 'a')
])

keys.extend([
    EzKeyChord('M-s', utils.expand_with_other_keys([
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
    EzKey('M-b', lazy.hide_show_bar('top')),
    EzKey('M-v', lazy.hide_show_bar('bottom')),
])

# media keys
keys.extend([
    EzKey('<XF86AudioPlay>', lazy.spawn(f'{nixConfig.programs.sequence_detector} -g mpris play')),
    EzKey('<XF86AudioPause>', lazy.spawn(f'{nixConfig.programs.sequence_detector} -g mpris pause')),
    EzKey('<XF86AudioStop>', lazy.spawn(f'{nixConfig.programs.sequence_detector} -g mpris stop')),
    EzKey('<XF86AudioNext>', lazy.spawn(f'{nixConfig.programs.sequence_detector} -g mpris next')),
    EzKey('<XF86AudioPrev>', lazy.spawn(f'{nixConfig.programs.sequence_detector} -g mpris prev')),
    EzKey('<XF86AudioMute>', lazy.spawn('amixer -D pulse set Master 1+ toggle')),
    EzKey('<XF86MonBrightnessUp>', lazy.spawn(f'{nixConfig.scripts.brightness} up')),
    EzKey('<XF86MonBrightnessDown>', lazy.spawn(f'{nixConfig.scripts.brightness} down')),
])

# Printscreen
keys.extend([
    EzKey('<Print>', lazy.spawn('ksnip -r')),
    # EzKey('S-<Print>', lazy.spawn('ksnip -r -s')),
])

# Locking
keys.extend([
    EzKey('M-S-n', lazy.spawn('loginctl lock-session')),
])

# Qtile control
keys.extend([
    EzKey('M-S-c', lazy.window.kill()),
    EzKey('M-C-r', lazy.reload_config()),
    EzKey('M-C-S-r', lazy.restart()),
    EzKey('M-C-q', lazy.shutdown()),
])

init_navigation_keys(keys, screens)

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

groups = [Group(i) if not (i in group_defaults.keys()) else Group(i, **group_defaults.get(i)) for i in '123456789']

for i in groups:
    keys.extend(
        [
            EzKey(
                f'M-{i.name}',
                functions.go_to_group(i.name),
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
            'ipcam',
            ['/home/ruther/doc/utils/ip-cam.sh'],
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
        # DropDown(
        #     'proton',
        #     ['firefoxpwa', 'site', 'launch', '01HBD772V37WPQ3B2T7TQJ81PM'],
        #     match = Match(wm_class = 'FFPWA-01HBD772V37WPQ3B2T7TQJ81PM'),
        #     on_focus_lost_hide = True,
        #     x = 0.025, y = 0.025,
        #     width = 0.95, height = 0.95,
        #     opacity = 1,
        # ),
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
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
    ]
)
auto_fullscreen = True
focus_on_window_activation = 'never'
reconfigure_screens = True
auto_minimize = True
bring_front_click = False

wl_input_rules = {}
wmname = 'LG3D'

# Swallow windows,
# when a process with window spawns
# another process with a window as a child, minimize the first
# winddow. Turn off the minimization after the child process
# is done.
# @hook.subscribe.client_new
#   I don't like this much :( hence I commented it out
# def _swallow(window):
#     pid = window.window.get_net_wm_pid()
#     ppid = psutil.Process(pid).ppid()
#     cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
#     for i in range(5):
#         if not ppid:
#             return
#         if ppid in cpids:
#             parent = window.qtile.windows_map.get(cpids[ppid])
#             parent.minimized = True
#             window.parent = parent
#             return
#         ppid = psutil.Process(ppid).ppid()

# # @hook.subscribe.client_killed
# def _unswallow(window):
#     if hasattr(window, 'parent'):
#         window.parent.minimized = False

# Startup setup,
# windows to correct workspaces,
# start autostart.sh
@hook.subscribe.startup_once
def autostart():
    import subprocess
    # subprocess.call([f'{configLocation}/autostart.sh'])

    for hook in nixConfig.startup.hooks:
        subprocess.Popen(hook.split())
    for app in nixConfig.startup.apps:
        subprocess.Popen(app.split())


@hook.subscribe.startup
async def observer_start():
    await observe_monitors()

firefoxInstance = 0
@hook.subscribe.client_new
def startup_applications(client: Window):
    global firefoxInstance

    if not isinstance(client, Window):
        return

    if client.match(Match(wm_class = 'firefox')) and firefoxInstance <= 1:
        client.togroup(groups[firefoxInstance].name)
        firefoxInstance += 1
    elif client.match(Match(wm_class = 'discord')) or client.match(Match(wm_class = 'telegram-desktop')) or client.match(Match(wm_class = 'element')):
        client.togroup(groups[8].name)

# Turn off fullscreen on unfocus
@hook.subscribe.client_focus
def exit_fullscreen_on_focus_changed(client: Window):
    windows = client.group.windows
    window: Window
    for window in windows:
        if window != client and window.fullscreen:
            window.toggle_fullscreen()


@hook.subscribe.startup_complete
def hide_bottom_bar():
    for screen in qtile.screens:
        bar = screen.bottom
        if isinstance(bar, libqtile.bar.Bar):
            bar.show(False)

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
