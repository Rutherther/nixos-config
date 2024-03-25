from threading import Timer
from libqtile.lazy import lazy
from libqtile.config import Click, Drag, Group, KeyChord, EzKey, Match, Screen, ScratchPad, DropDown, Key

def debounce(wait):
    """ Decorator that will postpone a functions
        execution until after wait seconds
        have elapsed since the last time it was invoked. """
    def decorator(fn):
        def debounced(*args, **kwargs):
            def call_it():
                fn(*args, **kwargs)
            try:
                debounced.t.cancel()
            except(AttributeError):
                pass
            debounced.t = Timer(wait, call_it)
            debounced.t.start()
        return debounced
    return decorator


# expands list of keys with the rest of regular keys,
# mainly usable for KeyChords, where you want any other key
# to exit the key chord instead.
def expand_with_other_keys(keys: list[EzKey], global_prefix: str) -> list[EzKey]:
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
