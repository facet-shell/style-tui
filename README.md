# facet · look-tui

The tui look: everything on screen in square frames and one monospace font, like a
terminal. The bar, launcher, lockscreen, notifications, control center, OSD, screenshots,
drawing, the editors, the media, wallpaper, keyboard and settings apps, the login screen
(greetd), the boot splash and GRUB menu, and the GTK theme. It sits on
[core](https://github.com/facet-shell/core), which holds the services they show.

Part of [facet](https://github.com/facet-shell); install it with the `facet` command:

```bash
facet add look-tui
```

Files in the package folders are linked into your home with GNU Stow; files with colors come
from `templates/` and are written by `facet theme` in the active theme. Ideas and bugs:
[the board](https://github.com/orgs/facet-shell/projects/1).
