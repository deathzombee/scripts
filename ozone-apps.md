# ozone and password store for desktop apps

desktop files I need to edit when they update because they use ozone fix / need to specify secret

- signal
- ~~obsidian~~

> example in the Desktop file:

```
Exec= signal-desktop --password-store="gnome-libsecret" --ozone-platform=wayland -- %u
```

(for signal optionally add --enable-dev-tools )
