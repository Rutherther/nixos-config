# DWL
I use DWL version 0.7 now.

## Patches
- singletagset

- swallow
- movestack
- naturalscrolltrackpad
- namedscratchpads
- bottomstack
- accessnthmonitor
- accessnthmonitor-movemouse
- focusnthclient
- alwayscenter
- keyboardshortcutsinhibit
- singletagset-pertag
  - adds single pertag set of rules for all monitors
- sticky
- singletagset-sticky
  - makes sticky compatible with singletagset

- ipc

- keycodes

## Mine unpublished
- singletagset-pertag-ipc-compat
  - use dwl functions for view, tag etc.
  - makes sure pertag rules are respected
  - and singletagset rules applied
- singletagset-ipc
  - Tweaks for ipc
  - show vacant tags on all monitors
  - add ACTIVE_OTHER state that says tag is active, but on another monitor
- applybounds-relative
  - when switching monitor of client put it to same relative position as previously
