import libqtile
from libqtile.lazy import lazy
from libqtile.core.manager import Qtile
from libqtile.backend.base import Window
from libqtile.config import Click, Drag, Group, KeyChord, EzKey, EzKeyChord, Match, Screen, ScratchPad, DropDown, Key

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
def warp_cursor_to_focused_window(qtile: Qtile):
    current_window = qtile.current_window
    win_size = current_window.get_size()
    win_pos = current_window.get_position()

    x = win_pos[0] + win_size[0] // 2
    y = win_pos[1] + win_size[1] // 2

    qtile.core.warp_pointer(x, y)

@lazy.function
def go_to_screen(qtile: Qtile, index: int):
    current_screen = qtile.current_screen
    screen = qtile.screens[index]

    if current_screen == screen:
        x = screen.x + screen.width // 2
        y = screen.y + screen.height // 2
        qtile.core.warp_pointer(x, y)

    qtile.to_screen(index)

    if qtile.current_group != None:
        qtile.current_group.focus(qtile.current_group.current_window)
    if qtile.current_window != None:
        qtile.current_window.focus()

@lazy.function
def go_to_group(qtile: Qtile, group_name: str, switch_monitor: bool = False):
    found = False
    current_group = qtile.current_group
    if group_name == current_group.name:
        warp_cursor_to_focused_window()
        return

    current_screen = qtile.current_screen
    target_screen = current_screen

    for screen in qtile.screens:
        if screen.group.name == group_name:
            target_screen = screen
            if switch_monitor:
                qtile.focus_screen(screen.index)
            found = True
            break

    current_bar = current_screen.top
    target_bar = target_screen.top

    if found and current_bar != target_bar and isinstance(target_bar, libqtile.bar.Bar) and isinstance(current_bar, libqtile.bar.Bar):
        # found on other monitor, so switch bars
        target_bar_show = target_bar.is_show()
        current_bar_show = current_bar.is_show()

        current_bar.show(target_bar_show)
        target_bar.show(current_bar_show)

    qtile.groups_map[group_name].toscreen()

    for window in current_group.windows:
        if window.fullscreen:
            window.toggle_fullscreen()
            # time.sleep(0.1)
            window.toggle_fullscreen()

    if not switch_monitor or not found:
        window: Window
        for window in qtile.groups_map[group_name].windows:
            if window.fullscreen:
                window.toggle_fullscreen()
                # time.sleep(0.1)
                window.toggle_fullscreen()
