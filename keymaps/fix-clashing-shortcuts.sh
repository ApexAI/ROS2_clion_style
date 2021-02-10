#!/bin/bash
set -euo pipefail

# Disables Ubuntu shortcuts that clash with IntelliJ Idea (and probably other
# Jetbrain products).
#
# Creates a backup file to restore the previous settings. To not have some
# shortcuts disabled, comment them out in the `KEYS` array.
#
# Tested on : Ubuntu 15.10
# Author    : Jonas Gröger <jonas.groeger@posteo.de>
# https://askubuntu.com/questions/412046/unable-to-use-intellij-idea-keyboard-shortcuts-on-ubuntu

readonly BACKUP_FILE="undo-fix-shortcuts-$(date +%s%N).sh"
readonly KEYS=(
    "/org/gnome/desktop/wm/keybindings/toggle-shaded"
    "/org/gnome/settings-daemon/plugins/media-keys/screensaver"
#    "/org/gnome/settings-daemon/plugins/media-keys/terminal"
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-down"
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-up"
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-left"
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-right"
    "/org/gnome/desktop/wm/keybindings/begin-move"
    "/org/gnome/desktop/wm/keybindings/begin-resize"
    # To disable resetting a value, just comment out the line
)
readonly DISABLED_VALUE="['disabled']"

main() {
    # Make backup
    printf "#!/bin/bash\n" >>  "$BACKUP_FILE"
    for key in "${KEYS[@]}"; do
        local value
        value=$(dconf read "$key")
        printf "dconf write \"%s\" \"%s\"\n" "$key" "$value" >> "$BACKUP_FILE"
    done

    # Disable all Ubuntu shortcuts
    for key in "${KEYS[@]}"; do
        dconf write "$key" "$DISABLED_VALUE"
    done

    dconf write "/org/gnome/settings-daemon/plugins/media-keys/screensaver" "'<Primary><Alt>Delete'"
}
main
