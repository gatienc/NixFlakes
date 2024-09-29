<h1 align="center">
   <img src="./assets/logo/kiki.png" width="600px" /> 
   <br>
      Gatien NixOS Flakes
   <br>

   <div align="center">
      <p></p>
      <div align="center">
         <a href="https://github.com/gatienc/NixFlakes/">
            <img src="https://img.shields.io/github/repo-size/gatienc/NixFlakes?color=B16286&labelColor=282828&style=for-the-badge&logo=github&logoColor=B16286">
         </a>
         <a href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=282828&logo=NixOS&logoColor=458588&color=458588">
         </a>
         <a href="https://github.com/gatienc/NixFlakes/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=282828&colorB=98971A&logo=unlicense&logoColor=98971A&"/>
         </a>
      </div>
      <br>

   </div>
</h1>

### 🖼️ Gallery

<p align="center">
   <img src="./assets/screenshot/desktop.png" style="margin-bottom: 10px;"/> <br>
   <img src="./assets/screenshot/prog.png" style="margin-bottom: 10px;"/> <br>
   <img src="./.github/assets/screenshots/3.png" style="margin-bottom: 10px;"/> <br>
   Screenshots last updated <b>2024-09-28</b>
   </p>

## 📚 Layout

- [flake.nix](flake.nix) base of the configuration
- [hosts](hosts) 🌳 per-host configurations that contain machine specific configurations and select the specied modules
  - [Glacius](hosts/glacius/) 🖥️ Desktop specific configuration
  - [icicle](hosts/icicle/) 💻 Laptop specific configuration
  - [vm](hosts/droplet/) 🗄️ Raspberry pi specific configuration
- [modules](modules) 🍱 modularized NixOS configurations
  - [core](modules/core/) ⚙️ Core config
  - [homes](modules/home/) 🏠 [Home-Manager](https://github.com/nix-community/home-manager) config
- [wallpapers](assets/wallpaper/) 🌄 wallpapers collection

```bash
sudo nixos-rebuild switch --flake .#HOSTNAME
```

`initialHashedPassword`

```sh
$ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
Password: your password
<hash output>
```

Find the new files created:

```sh
 sudo fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd}" | fzf
```

## 📝 Shell aliases

<details>
<summary>
Utils (EXPAND)
</summary>

- `c` $\rightarrow$ `clear`
- `cd` $\rightarrow$ `z`
- `tt` $\rightarrow$ `gtrash put`
- `vim` $\rightarrow$ `nvim`
- `cat` $\rightarrow$ `bat`
- `nano` $\rightarrow$ `micro`
- `code` $\rightarrow$ `codium`
- `py` $\rightarrow$ `python`
- `icat` $\rightarrow$ `kitten icat`
- `dsize` $\rightarrow$ `du -hs`
- `pdf` $\rightarrow$ `tdf`
- `open` $\rightarrow$ `xdg-open`
- `space` $\rightarrow$ `ncdu`
- `man` $\rightarrow$ `BAT_THEME='default' batman`
- `l` $\rightarrow$ `eza --icons  -a --group-directories-first -1`
- `ll` $\rightarrow$ `eza --icons  -a --group-directories-first -1 --no-user --long`
- `tree` $\rightarrow$ `eza --icons --tree --group-directories-first`
</details>

## Todo

- [ ] Add more wallpapers
- [ ] Modularize the elements of the configuration (Desktop environment, Programs, etc)

## Credits

Thanks to Will Bush, Vimjoyer and Frost-Phoenix which were the inspiration for this flake.
