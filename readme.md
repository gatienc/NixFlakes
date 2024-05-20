# Gatien NixOS Flakes


heavily inspired from Will Bush and Vimjoyer


```bash
sudo nixos-rebuild switch --flake .#blitzar
```

`initialHashedPassword`

```sh
$ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
Password: your password
<hash output>
```
