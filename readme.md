# Gatien NixOS Flakes


heavily inspired from Will Bush and Vimjoyer


```bash
sudo nixos-rebuild switch --flake .#glacius
```

`initialHashedPassword`

```sh
$ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
Password: your password
<hash output>
```



snippets to find the new files created
```sh
 sudo fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd}" | fzf
```


I am using 
/home/gatien/.local/share/fonts/Google/TrueType/Apple Color Emoji/Apple_Color_Emoji_Regular.ttf