<p align="center">
  <a href="https://github.com/facet-shell"><img src="https://raw.githubusercontent.com/facet-shell/.github/main/brand/mark.svg" alt="facet" width="64"></a>
</p>

<h3 align="center">style-tui</h3>

<p align="center">The tui style: square frames and one monospace font.</p>

<p align="center"><sub><a href="https://github.com/facet-shell">facet</a> · <a href="https://github.com/facet-shell/core">core</a> · <a href="https://github.com/facet-shell/cli">cli</a> &nbsp;|&nbsp; <b>tui</b> · <a href="https://github.com/facet-shell/style-bloom">bloom</a> &nbsp;|&nbsp; <a href="https://github.com/facet-shell/terminal">terminal</a> · <a href="https://github.com/facet-shell/spotify">spotify</a> · <a href="https://github.com/facet-shell/discord">discord</a> · <a href="https://github.com/facet-shell/steam">steam</a> · <a href="https://github.com/facet-shell/zed">zed</a> · <a href="https://github.com/facet-shell/zen">zen</a> · <a href="https://github.com/facet-shell/dolphin">dolphin</a> · <a href="https://github.com/facet-shell/keyboard">keyboard</a> &nbsp;|&nbsp; <a href="https://facet-shell.github.io">website</a> · <a href="https://github.com/orgs/facet-shell/projects/1">board</a></sub></p>

The tui style: everything on screen in square frames and one monospace font, like a
terminal. The bar, launcher, lockscreen, notifications, control center, OSD, screenshots,
drawing, the editors, the media, wallpaper, keyboard and settings apps, the login screen
(greetd), the boot splash and GRUB menu, and the GTK theme. It sits on
[core](https://github.com/facet-shell/core), which holds the services they show.

Part of [facet](https://github.com/facet-shell); install it with the `facet` command:

```bash
facet add style-tui
```

Files in the package folders are linked into your home with GNU Stow; files with colors come
from `templates/` and are written by `facet theme` in the active theme. Ideas and bugs:
[the board](https://github.com/orgs/facet-shell/projects/1).

## Glint wallpapers

Install the matching core and CLI updates with `facet install quickshell hypr wallpaper`.
Super+W controls Glint directly, including target display selection, frame rate,
volume, scaling and the selected wallpaper's authored properties. The background
surface yields to Glint on assigned displays, and locking pauses its rendering.
The standalone `glint tui` interface is independent of this Quickshell style.

Run the offscreen native-view smoke test from core with
`python3 tests/glint/run-smoke.py --tui /path/to/style-tui`.
