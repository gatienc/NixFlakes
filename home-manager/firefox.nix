{inputs, config ,pkgs, ...}:
{
    programs.firefox = {
        enable = true;
        profiles.gatien = 
        {
            extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
                bitwarden
                ublock-origin
            ];
        };
    };
    
}
