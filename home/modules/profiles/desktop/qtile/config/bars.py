import subprocess
import re
from libqtile import layout, bar, qtile
from qtile_extras.widget.decorations import BorderDecoration, PowerLineDecoration, RectDecoration
import qtile_extras.widget as widget
from nixenvironment import nixConfig
from libqtile.widget import Mpris2
from tasklist import TaskList

def create_top_bar(systray = False):
    powerline = {
        'decorations': [
            PowerLineDecoration(path = 'forward_slash')
        ]
    }

    widgets = [
        widget.Sep(padding = 5, size_percent = 0, background = nixConfig.theme.background.secondary),
        widget.CurrentScreen(
            active_text = 'I',
            active_color = nixConfig.theme.foreground.active,
            padding = 3,
            fontsize = 16,
            background = nixConfig.theme.background.secondary,
        ),
        widget.GroupBox(
            markup = False,
            highlight_method = 'line',
            rounded = False,
            margin_x = 2,
            disable_drag = True,
            use_mouse_wheel = True,
            active = nixConfig.theme.foreground.activeAlt,
            inactive = nixConfig.theme.foreground.inactive,
            urgent_alert_method = 'line',
            urgent_border = nixConfig.theme.urgent,
            this_current_screen_border = nixConfig.theme.foreground.active,
            this_screen_border = nixConfig.theme.foreground.secondary,
            other_screen_border = nixConfig.theme.background.inactive,
            other_current_screen_border = '6989c0',
            background = nixConfig.theme.background.secondary,
        ),
        widget.CurrentScreen(
            active_text = 'I',
            active_color = nixConfig.theme.foreground.active,
            padding = 3,
            fontsize = 16,
            background = nixConfig.theme.background.secondary,
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
            foreground = nixConfig.theme.foreground.primary,
            width = bar.CALCULATED,
            padding = 10,
            empty_group_string = 'Desktop',
            max_chars = 160,
            decorations = [
                RectDecoration(
                    colour = nixConfig.theme.background.box,
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
                    colour = nixConfig.theme.background.box,
                    radius = 0,
                    padding_y = 4,
                    padding_x = 6,
                    filled = True,
                    clip = True,
                ),
            ]
        ),
        # widget.Net(
        #     interface = 'enp24s0',
        #     prefix='M',
        #     format = '{down:6.2f} {down_suffix:<2}↓↑{up:6.2f} {up_suffix:<2}',
        #     background = nixConfig.theme.background.secondary,
        #     **powerline,
        # ),
        widget.Memory(
            format = '{MemFree: .0f}{mm}',
            fmt = '{} free',
            **powerline,
        ),
        widget.CPU(
            format = '{load_percent} %',
            fmt = '   {}',
            background = nixConfig.theme.background.secondary,
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
            foreground = nixConfig.theme.foreground.primary,
            format='%A, %B %d - %H:%M:%S',
            background = nixConfig.theme.background.secondary,
            **powerline
        ),
        widget.Volume(
            fmt = '🕫  {}',
        ),
        widget.Sep(
            foreground = nixConfig.theme.background.secondary,
            size_percent = 70,
            linewidth = 3,
        ),
        # Bluetooth(
        #     device = '/dev_88_C9_E8_49_93_16',
        #     symbol_connected = '',
        #     symbol_paired = ' DC\'d',
        #     symbol_unknown = '',
        #     symbol_powered = ('', ''),
        #     device_format = '{battery_level}{symbol}',
        #     device_battery_format = ' {battery} %',
        #     format_unpowered = '',
        # ),
    ]

    if systray:
        widgets.append(widget.Sep(
            foreground = nixConfig.theme.background.secondary,
            size_percent = 70,
            linewidth = 2,
        ))
        widgets.append(widget.Systray())
        widgets.append(widget.Sep(padding = 5, size_percent = 0))

    return bar.Bar(widgets, 30)

def create_bottom_bar():
    powerline = {
        'decorations': [
            PowerLineDecoration(path = 'forward_slash')
        ]
    }

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
            format = '{xesam:title}',
            playerfilter = '.*Firefox.*',
            scroll = False,
            paused_text = '', #'   {track}',
            playing_text = '    {track}',
            padding = 10,
            decorations = [
                RectDecoration(
                    colour = nixConfig.theme.background.box,
                    radius = 0,
                    padding_y = 4,
                    padding_x = 5,
                    filled = True,
                    clip = True,
                ),
            ],
        ),
        Mpris2(
            format = '{xesam:title} - {xesam:artist}',
            objname = 'org.mpris.MediaPlayer2.spotify',
            scroll = False,
            paused_text = '', #'   {track}',
            playing_text = '  {track}', # '   {track}',
            padding = 10,
            decorations = [
                RectDecoration(
                    colour = nixConfig.theme.background.box,
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
            background = nixConfig.theme.background.secondary,
            **powerline,
        ),
    ], 30)
