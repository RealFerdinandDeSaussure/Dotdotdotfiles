import os
from random import choice
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

config = config
c = c

start_pages = ["https://www.freitag.de/", "https://www.punknews.org/"]


def get_rgba(hexcode, alpha):
    hextuple = tuple(bytes.fromhex(hexcode[1:]))
    rgba = "{0}, {1}, {2}, ".format(*hextuple) + alpha
    return "rgba({})".format(rgba)


def merge_bookmarks():
    """Merge bookmarks from the cloud with those kept by qutebrowser."""
    int_bookmarks = os.path.join(config.configdir, "bookmarks", "urls")
    int_quickmarks = os.path.join(config.configdir, "quickmarks")
    ext_bookmarks = os.path.join(
        os.getenv("HOME"), "Sync", "Diverses", "Qutemarks", "book"
    )
    ext_quickmarks = os.path.join(
        os.getenv("HOME"), "Sync", "Diverses", "Qutemarks", "quick"
    )
    for mark_files in (
        (int_bookmarks, ext_bookmarks),
        (int_quickmarks, ext_quickmarks),
    ):
        try:
            with open(mark_files[1], mode="r") as f:
                marks = f.read()
            with open(mark_files[0], mode="w") as f:
                f.write(marks)
        except (FileNotFoundError, TypeError):
            return


BASE00 = "#{}".format(os.getenv("__BASE00") or "262626")  # black0
BASE01 = "#{}".format(os.getenv("__BASE01") or "3a3a3a")  # black1
BASE02 = "#{}".format(os.getenv("__BASE02") or "4e4e4e")  # black2
BASE03 = "#{}".format(os.getenv("__BASE03") or "8a8a8a")  # black3
BASE04 = "#{}".format(os.getenv("__BASE04") or "949494")  # black4
BASE05 = "#{}".format(os.getenv("__BASE05") or "dab997")  # white0
BASE06 = "#{}".format(os.getenv("__BASE06") or "d5c4a1")  # white1
BASE07 = "#{}".format(os.getenv("__BASE07") or "ebdbb2")  # white2
BASE08 = "#{}".format(os.getenv("__BASE08") or "d75f5f")  # red
BASE09 = "#{}".format(os.getenv("__BASE09") or "ff8700")  # light_orange
BASE0A = "#{}".format(os.getenv("__BASE0A") or "ffaf00")  # yellow
BASE0B = "#{}".format(os.getenv("__BASE0B") or "afaf00")  # green
BASE0C = "#{}".format(os.getenv("__BASE0C") or "85ad85")  # cyan
BASE0D = "#{}".format(os.getenv("__BASE0D") or "83adad")  # blue
BASE0E = "#{}".format(os.getenv("__BASE0E") or "d485ad")  # magenta
BASE0F = "#{}".format(os.getenv("__BASE0F") or "d65d0e")  # dark_orange

FONT_SANS = os.getenv("FONT_SANS")
FONT_MONO = os.getenv("FONT_TERMINAL")

merge_bookmarks()

# no autoconfig
config.load_autoconfig(False)

## Color settings
# Background color of the completion widget category headers.
c.colors.completion.category.bg = BASE02
# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = BASE02
# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = BASE00
# Foreground color of completion widget category headers.
c.colors.completion.category.fg = BASE07
# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = BASE00
# Background color of the completion widget for even rows.
c.colors.completion.even.bg = BASE01
# Text color of the completion widget.
c.colors.completion.fg = BASE07
# Background color of the selected completion item.
c.colors.completion.item.selected.bg = BASE07
# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = BASE07
# Top border color of the completion widget category headers.
c.colors.completion.item.selected.border.top = BASE07
# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = BASE00
# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = BASE08
# Color of the scrollbar in completion view
c.colors.completion.scrollbar.bg = BASE01
# Color of the scrollbar handle in completion view.
c.colors.completion.scrollbar.fg = BASE07
# Background color for the download bar.
c.colors.downloads.bar.bg = BASE00
# Background color for downloads with errors.
c.colors.downloads.error.bg = BASE08
# Foreground color for downloads with errors.
c.colors.downloads.error.fg = BASE07
# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = BASE0D
# Color gradient start for download text.
c.colors.downloads.start.fg = BASE00
# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = BASE0B
# Color gradient end for download text.
c.colors.downloads.stop.fg = BASE00
# Color gradient interpolation system for download backgrounds.
# Valid values:
c.colors.downloads.system.bg = "rgb"
# Color gradient interpolation system for download text.
# Valid values:
c.colors.downloads.system.fg = "rgb"
# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = get_rgba(BASE02, "0.85")
# Font color for hints.
c.colors.hints.fg = BASE07
# Font color for the matched part of hints.
c.colors.hints.match.fg = BASE03
# Background color of the keyhint widget.
c.colors.keyhint.bg = get_rgba(BASE00, "0.9")
# Text color for the keyhint widget.
c.colors.keyhint.fg = BASE07
# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = BASE0A
# Background color of an error message.
c.colors.messages.error.bg = BASE08
# Border color of an error message.
c.colors.messages.error.border = BASE08
# Foreground color of an error message.
c.colors.messages.error.fg = BASE07
# Background color of an info message.
c.colors.messages.info.bg = BASE00
# Border color of an info message.
c.colors.messages.info.border = BASE01
# Foreground color an info message.
c.colors.messages.info.fg = BASE07
# Background color of a warning message.
c.colors.messages.warning.bg = BASE0F
# Border color of a warning message.
c.colors.messages.warning.border = BASE0F
# Foreground color a warning message.
c.colors.messages.warning.fg = BASE07
# Background color for prompts.
c.colors.prompts.bg = BASE02
# Border used around UI elements in prompts.
c.colors.prompts.border = "1px solid {}".format(BASE07)
# Foreground color for prompts.
c.colors.prompts.fg = BASE07
# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = BASE03
# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = BASE0F
# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = BASE07
# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = BASE0E
# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = BASE07
# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = BASE03
# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = BASE07
# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = BASE03
# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = BASE07
# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = BASE07
# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = BASE03
# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = BASE0F
# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = BASE07
# Background color of the statusbar.
c.colors.statusbar.normal.bg = BASE00
# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = BASE07
# Background color of the progress bar.
c.colors.statusbar.progress.bg = BASE07
# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = BASE09
# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = BASE07
# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = BASE0D
# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = BASE07
# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = BASE0C
# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = BASE0A
# Background color of the tab bar.
c.colors.tabs.bar.bg = BASE03
# Background color of unselected even tabs.
c.colors.tabs.even.bg = BASE02
# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = BASE07
# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = BASE08
# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = BASE0D
# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = BASE0B
# Color gradient interpolation system for the tab indicator.
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.tabs.indicator.system = "rgb"
# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = BASE01
# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = BASE07
# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = BASE07
# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = BASE00
# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = BASE07
# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = BASE00
# Background color for webpages if unset (or empty to use the theme's
# color)
c.colors.webpage.bg = "white"
# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = BASE07
# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = BASE00


## Font settings
# Only let completion use up as little space as possible
c.completion.shrink = True
# Font used in the completion categories.
c.fonts.completion.category = "bold 10pt {}".format(FONT_MONO)
# Font used in the completion widget.
c.fonts.completion.entry = "10pt {}".format(FONT_MONO)
# Font used for the debugging console.
c.fonts.debug_console = "10pt {}".format(FONT_MONO)
# Font used for the downloadbar.
c.fonts.downloads = "10pt {}".format(FONT_SANS)
# Font used for the hints.
c.fonts.hints = "10pt {}".format(FONT_MONO)
# Font used in the keyhint widget.
c.fonts.keyhint = "10pt {}".format(FONT_SANS)
# Font used for error messages.
c.fonts.messages.error = "10pt {}".format(FONT_SANS)
# Font used for info messages.
c.fonts.messages.info = "10pt {}".format(FONT_SANS)
# Font used for warning messages.
c.fonts.messages.warning = "10pt {}".format(FONT_SANS)
# Font used for prompts.
c.fonts.prompts = "10pt {}".format(FONT_SANS)
# Font used in the statusbar.
c.fonts.statusbar = "10pt {}".format(FONT_MONO)
# Font used in the tab bar.
c.fonts.tabs.selected = "500 10pt {}".format(FONT_SANS)
c.fonts.tabs.unselected = "10pt {}".format(FONT_SANS)
## Font family for sans-serif fonts.
c.fonts.web.family.sans_serif = "Liberation Sans"
## Font family for serif fonts.
c.fonts.web.family.serif = "Liberation Serif"
# Nice looking padding for tabs headers
c.tabs.padding = {"top": 2, "bottom": 2, "left": 3, "right": 3}

## Hint settings
# Mode to use for hints.
c.hints.mode = "letter"
c.hints.chars = "asdfghjklö"
# A comma-separated list of regexes to use for 'next' links.
c.hints.next_regexes = [
    "\\bnext\\b",
    "\\bmore\\b",
    "\\bnewer\\b",
    "\\b[>→≫]\\b",
    "\\b(>>|»)\\b",
    "\\bcontinue\\b",
]
# A comma-separated list of regexes to use for 'prev' links.
c.hints.prev_regexes = [
    "\\bprev(ious)?\\b",
    "\\bback\\b",
    "\\bolder\\b",
    "\\b[<←≪]\\b",
    "\\b(<<|«)\\b",
]
# Time from pressing a key to seeing the keyhint dialog (ms).
c.keyhint.delay = 200
# A timeout (in milliseconds) to ignore normal-mode key bindings after a
# successful auto-follow.
c.hints.auto_follow_timeout = 300
# setup hints border
c.hints.border = "1px solid {}".format(BASE04)

## Address bar shortcut settings
# Definitions of search engines which can be used via the address bar.
c.url.open_base_url = True
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/index.php?search={}",
    "bc": "https://bandcamp.com/search?q={}",
    "bgg": "https://boardgamegeek.com/geeksearch.php?action=search&objecttype=boardgame&q={}",
    "fm": "https://www.last.fm/search?q={}",
    "g": "https://encrypted.google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "lc": "https://dict.leo.org/chinesisch-deutsch/{}",
    "le": "https://dict.leo.org/german-english/{}",
    "lf": "https://dict.leo.org/französisch-deutsch/{}",
    "li": "https://dict.leo.org/italienisch-deutsch/{}",
    "mel": "http://melpa.org/#/?q={}",
    "py": "https://docs.python.org/3/search.html?q={}",
    "ug": "https://www.ultimate-guitar.com/search.php?search_type=title&value={}",
    "w": "https://en.wikipedia.org/w/index.php?search={}",
    "wd": "https://de.wikipedia.org/w/index.php?search={}",
    "wv": "https://en.wikivoyage.org/w/index.php?search={}",
    "yt": "https://farside.link/invidious/search?q={}",
}

# Aliases
c.aliases["ssh-tunnel"] = (
    "config-cycle --temp content.proxy socks://localhost:4711 system"
)

## Miscellaneous settings
# Start page
c.url.start_pages = [
    choice(start_pages),
]
# Where to show the downloaded files.
c.downloads.position = "bottom"
# Open new tabs in background
c.tabs.background = True
# Don't store cookies because I don't like them
c.content.cookies.store = False
# Use default Firefox HTTP_ACCEPT header
c.content.headers.accept_language = "de-DE,de;q=0.5"
c.content.headers.custom = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
}
# Set editor
c.editor.command = ["alacritty", "-e", 'nvim -c "normal {line}G{column0}l" {file}']
# Which tab to select when the focused tab is removed.
c.tabs.select_on_remove = "last-used"
# Confirm exit when there's downloads running
c.confirm_quit = ["downloads"]

## Key bindings
# Deletion
config.unbind("d", mode="normal")
config.unbind("D", mode="normal")
config.bind("dd", "tab-close")
config.bind("dD", "tab-only")
config.bind("dk", "tab-close --prev")
config.bind("dj", "tab-close --next")
config.bind("dK", "tab-only --next")
config.bind("dJ", "tab-only --prev")
config.bind("dq", "cmd-set-text --space :quickmark-del")
config.bind("db", "cmd-set-text --space :bookmark-del")
# Tab moving
config.bind("<Alt-Shift-J>", "tab-move +")
config.bind("<Alt-Shift-K>", "tab-move -")
# direct tab selection
config.bind("g1", "tab-focus 1")
config.bind("g2", "tab-focus 2")
config.bind("g3", "tab-focus 3")
config.bind("g4", "tab-focus 4")
config.bind("g5", "tab-focus 5")
config.bind("g6", "tab-focus 6")
config.bind("g7", "tab-focus 7")
config.bind("g8", "tab-focus 8")
config.bind("g9", "tab-focus 9")
config.bind("g0", "tab-focus 1")
# Clear search highlighting
config.bind("<Ctrl-´>", "search")
# Quickmark/Bookmark opening
config.bind("gm", "cmd-set-text --space :bookmark-load")
config.bind("gM", "cmd-set-text --space :bookmark-load -t")
# bind mute command
config.bind("am", "tab-mute")
# Completion navigation command mode
config.bind("<Alt-k>", "command-history-prev", mode="command")
config.bind("<Alt-j>", "command-history-next", mode="command")
config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "completion-item-focus prev", mode="command")
# Additional hinting
config.bind("e", "hint all hover", mode="normal")
config.bind(";o", "cmd-set-text --space :open -b")
config.bind(";O", "cmd-set-text --space :open -p")
config.bind(";p", "hint images yank")
config.bind(";v", "hint links userscript mpv-play")
config.bind(
    ";a",
    "hint links spawn --detach mpv --no-video --player-operation-mode=pseudo-gui {hint-url}",
)
config.bind(";x", "hint links userscript xdg-open")
# Open current url in new windows
config.unbind("wO", mode="normal")
config.bind("gw", "cmd-set-text :open -w {url:pretty}")
# Open alternative frontend for current page
config.bind("g_", "spawn -u alt_frontend")
# Buffer navigation
config.bind("b", "cmd-set-text --space :tab-select")
# Source config
config.bind("<Ctrl-R>", "config-source")
# Passthrough settings
config.unbind("<Ctrl-v>")
config.bind("I", "mode-enter passthrough")
config.bind("<Escape>", "mode-leave", mode="passthrough")
config.bind("<Shift-Escape>", "fake-key <Escape>", mode="passthrough")
config.bind("<Shift-Escape>", "fake-key <Escape>")
# emacsy input keybindings in command mode
config.bind("<Ctrl-a>", "rl-beginning-of-line", mode="command")
config.bind("<Ctrl-e>", "rl-end-of-line", mode="command")
config.bind("<Ctrl-b>", "rl-backward-char", mode="command")
config.bind("<Ctrl-f>", "rl-forward-char", mode="command")
config.bind("<Ctrl-Shift-b>", "rl-backward-word", mode="command")
config.bind("<Ctrl-Shift-f>", "rl-forward-word", mode="command")
config.bind("<Ctrl-q>", "edit-text", mode="insert")
# emacsy input keybindings in prompt mode
config.bind("<Ctrl-a>", "rl-beginning-of-line", mode="prompt")
config.bind("<Ctrl-e>", "rl-end-of-line", mode="prompt")
config.bind("<Ctrl-b>", "rl-backward-char", mode="prompt")
config.bind("<Ctrl-f>", "rl-forward-char", mode="prompt")
config.bind("<Ctrl-Shift-b>", "rl-backward-word", mode="prompt")
config.bind("<Ctrl-Shift-f>", "rl-forward-word", mode="prompt")
# one day these might be supported in insert mode as well... until then at
# least unbind them
config.unbind("<Ctrl-e>", mode="insert")
