# Linux Package Management Quick Reference

| Family | Search | Install | Update metadata | Remove |
|---|---|---|---|---|
| Debian/Ubuntu | `apt search NAME` | `sudo apt install NAME` | `sudo apt update` | `sudo apt remove NAME` |
| Fedora | `dnf search NAME` | `sudo dnf install NAME` | `sudo dnf makecache` | `sudo dnf remove NAME` |
| Arch | `pacman -Ss NAME` | `sudo pacman -S NAME` | `sudo pacman -Sy`* | `sudo pacman -R NAME` |

*On Arch, avoid partial upgrades; prefer a full system upgrade with `sudo pacman -Syu`. Review package changes before confirming.
