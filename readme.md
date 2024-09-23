# Gatien NixOS Flakes

Heavily inspired from Will Bush and Vimjoyer

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
