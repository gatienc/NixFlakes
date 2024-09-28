# From https://github.com/Frost-Phoenix/nixos-config/tree/main
{ pkgs, ... }:
{
  home.packages = (with pkgs;
    [ fastfetch ]);

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "${../../assets/logo}/$(ls ${../../assets/logo}| shuf -n 1)",
        "type": "kitty-direct",
        "width": 33,
        "padding": {
          "top": 2,é
          "left": 2
        }
      },
      "display": {
        "separator": "",
        "size": {
            "binaryPrefix": "si",
          "ndigits": 0
        },
        "percent": {
          "type": 1
        },
        "key":{
         "Width": 1
         },
      },
      "modules": [
        {
          "type": "title",
          "color": {
            "user": "35",
            "host": "36"
          }
        },
        {
          "type": "separator",
          "string": "▔"
        },
        {
          "type": "os",
          "key": "╭─ ",
          "format": "{3} ({12})",
          "keyColor": "32"
        },
        {
          "type": "host",
          "key": "├─󰟀 ",
          "keyColor": "32"
        },
        {
          "type": "kernel",
          "key": "├─󰒔 ",
          "format": "{1} {2}",
          "keyColor": "32"
        },
        {
          "type": "shell",
          "key": "├─$ ",
          "format": "{1} {4}",
          "keyColor": "32"
        },
        {
          "type": "packages",
          "key": "├─ ",
          "keyColor": "32"
        },
        {
          "type": "uptime",
          "key": "╰─󰔚 ",
          "keyColor": "32"
        },
        "break",
       /* {
          "type": "cpu",
          "key": "╭─ ",
          "keyColor": "34",
          "freqNdigits": 1
        },
        {
          "type": "gpu",
          "key": "├─󰢮 ",
          "format": "{1} {2} ({3})",
          "keyColor": "34"
        },
        {
          "type": "sound",
          "key": "├─󰓃 ",
          "format": "{2}",
          "keyColor": "34"
        },
        {
          "type": "battery",
          "key": "├─󰁹 ",
          "keyColor": "34"
        },
        {
          "type": "memory",
          "key": "├─ ",
          "keyColor": "34"
        },
        {
          "type": "disk",
          "key": "├─󰋊 ",
          "keyColor": "34"
        },
        {
          "type": "localip",
          "key": "╰─󱦂 ",
          "keyColor": "34",
          "showIpv4": true,
          "compact": true
        },
        "break", */
        {
          "type": "display",
          "key": "╭─󰹑 ",
          "keyColor": "33",
          "compactType": "original"
        },
        {
          "type": "de",
          "key": "├─󰧨 ",
          "keyColor": "33"
        },
        {
          "type": "wm",
          "key": "├─ ",
          "keyColor": "33"
        },
        {
          "type": "theme",
          "key": "├─󰉼 ",
          "keyColor": "33"
        },
        {
          "type": "icons",
          "key": "├─ ",
          "keyColor": "33"
        },
        {
          "type": "cursor",
          "key": "├─󰳽 ",
          "keyColor": "33"
        },
        {
          "type": "font",
          "key": "├─ ",
          "format": "{2}",
          "keyColor": "33"
        },
        {
          "type": "terminal",
          "key": "╰─ ",
          "format": "{3}",
          "keyColor": "33"
        },
        "break",
        {
          "type": "colors",
          "symbol": "block"
        },
      ]
    }
  '';
}

##alternative modules :
#  "modules": [
#    //    {
#    //      "type": "",         // -
#    //      "key": "",          //Key of the module
#    //      "keyColor": "",     //Color of the module key. Left empty to use `display.color.keys`
#    //      "keyIcon": "",      //Set the icon to be displayed by `display.keyType: "icon"`
#    //      "keyWidth": "",     //Width of the module key. Use 0 to use `display.keyWidth`
#    //      "outputColor": "",  //Output color of the module. Left empty to use `display.color.output`
#    //      "format": "",       //Output format of the module. See `-h -format` for detail. I.e: fastfetch -h disk-format
#    //    },
#    //
#    // CUSTOM - Top UI bar
#    {
#      "type": "custom",
#      "key": "{#90}{$1}╭─────────────╮",
#      "format": "{#90}{$2}╭────────────────────────────────────────────────────────────╮",
#    },
#    {
#      "type": "title",
#      "key": "{#90}{$1}│ {#92}User        {#90}│",
#      //"fqdn": false,
#      "format": "{$2}{$3}{user-name} {#2}[{home-dir}]",
#      //fastfetch -h title-format
#      // {1}: User name - user-name
#      // {3}: Home directory - home-dir
#      // The default is something similar to "{6}{7}{8}".
#    },
#    {
#      "type": "users",
#      "key": "{#90}{$1}│ {#92}Users       {#90}│",
#      "myselfOnly": false,
#      "format": "{$2}{$3}{1}@{host-name}{/host-name}localhost{/}{?client-ip}  {#2}[IP:{client-ip}]{?}  {#2}[Login time: {login-time}]",
#      // fastfetch -h users-format
#      // {1}: User name - user-name
#      // {2}: Host name - host-name
#      // {3}: Session name - session
#      // {4}: Client IP - client-ip
#      // {5}: Login Time in local timezone - login-time
#      // The default is something similar to "{1}@{2} - login time {5}".
#    },
#    {
#      "type": "datetime",
#      "key": "{#90}{$1}│ {#92}Datetime    {#90}│",
#      "format": "{$2}{$3}{year}-{month-pretty}-{day-in-month}  {hour-pretty}:{minute-pretty}:{second-pretty}  {#2}{weekday}  {#2}[W{week}] {#2}[UTC{offset-from-utc}]",
#      //fastfetch -h datetime-format
#      // {1}: year - year
#      // {4}: month with leading zero - month-pretty
#      // {7}: week number on year - week
#      // {8}: weekday - weekday
#      // {11}: day in month - day-in-month
#      // {14}: hour with leading zero - hour-pretty
#      // {18}: minute with leading zero - minute-pretty
#      // {20}: second with leading zero - second-pretty
#      // {21}: offset from UTC in the ISO 8601 format - offset-from-utc
#      // The default is something similar to "{1}-{4}-{11} {14}:{18}:{20}".
#    },
#    {
#      "type": "title",
#      "key": "{#90}{$1}│ {#93}Host:       {#90}│",
#      //"fqdn": false,
#      "format": "{$2}{$3}{#1}{#36}{host-name}",
#      //fastfetch -h title-format
#      // {2}: Host name - host-name
#      // The default is something similar to "{6}{7}{8}".
#    },
#    {
#      "type": "host",
#      "key": "{#90}{$1}│ {#93}Machine     {#90}│",
#      "format": "{$2}{$3}{name} {#2}{version}",
#      // fastfetch -h host-format
#      // {2}: product name - name
#      // {3}: product version - version
#      // The default is something similar to "{2} {3}".
#    },
#    {
#      "type": "os",
#      "key": "{#90}{$1}│ {#93}OS          {#90}│",
#      "format": "{$2}{$3}{pretty-name} {codename} {#2}[v{version}] {#2}[{arch}]",
#      // fastfetch -h os-format
#      // {3}: Pretty name of the OS - pretty-name
#      // {8}: Version of the OS - version
#      // {10}: Version codename of the OS - codename
#      // {12}: Architecture of the OS - arch
#      // The default is something similar to "{3} {10} {12}".
#    },
#    {
#      "type": "kernel",
#      "key": "{#90}{$1}│ {#93}Kernel      {#90}│",
#      "format": "{$2}{$3}{sysname} {#2}[v{release}]",
#      // fastfetch -h kernel-format
#      // {1}: Sysname - sysname
#      // {2}: Release - release
#      // The default is something similar to "{1} {2}".
#    },
#    {
#      "type": "uptime",
#      "key": "{#90}{$1}│ {#93}Uptime      {#90}│",
#      //"format": "{$2}{$3}{days} Days {hours} Hours {minutes} Mins {seconds} Secs",
#      "format": "{$2}{$3}{?days}{days} Days + {?}{hours}:{minutes}:{seconds}",
#      // fastfetch -h uptime-format
#      // {1}: Days - days
#      // {2}: Hours - hours
#      // {3}: Minutes - minutes
#      // {4}: Seconds - seconds
#      // The default is something similar to "{1} days {2} hours {3} mins".
#    },
#    // {
#    //   "type": "board",
#    //   "key": "{#5;104}Board",
#    //   "format": "{2} {1}",
#    //   //fastfetch -h board-format
#    //   // {1}: board name - name
#    //   // {2}: board vendor - vendor
#    // },
#    {
#      "type": "cpu",
#      "key": "{#90}{$1}│ {#91}CPU         {#90}│",
#      "showPeCoreCount": true,
#      "temp": true,
#      "format": "{$2}{$3}{name} {#2}[C:{core-types}] {#2}[{freq-max}]",
#      // fastfetch -h cpu-format
#      // {1}: Name - name
#      // {7}: Max frequency (formatted) - freq-max
#      // {9}: Logical core count grouped by frequency - core-types
#      // The default is something similar to "{1} ({5}) @ {7} GHz".
#    },
#    {
#      "type": "gpu",
#      "key": "{#90}{$1}│ {#91}GPU         {#90}│",
#      "detectionMethod": "auto",
#      "driverSpecific": true,
#      "format": "{$2}{$3}{name} {#2}[C:{core-count}] {#2}[{type}]",
#      // fastfetch -h gpu-format
#      // {1}: GPU vendor - vendor
#      // {2}: GPU name - name
#      // {5}: GPU core count - core-count
#      // {6}: GPU type - type
#      // The default is something similar to "{1} {2}".
#    },
#    // {
#    //   "type": "physicalmemory",
#    //   "key": "Physical Memory",
#    // },
#    {
#      "type": "memory",
#      "key": "{#90}{$1}│ {#91}Memory      {#90}│",
#      "format": "{$2}{$3}{used} / {total} ({percentage}{$2})",
#      // fastfetch -h memory-format
#      // {1}: Used size - used
#      // {2}: Total size - total
#      // {3}: Percentage used (num) - percentage
#      // The default is something similar to "{1} / {2} ({3})".
#    },
#    // {
#    //   "type": "swap",
#    //   "key": "Swap",
#    // },
#    {
#      "type": "disk",
#      "key": "{#90}{$1}│ {#91}Disk        {#90}│",
#      "format": "{$2}{$3}{size-used} / {size-used} ({size-percentage}{$2})",
#      // fastfetch -h disk-format
#      // {1}: Size used - size-used
#      // {2}: Size total - size-total
#      // {3}: Size percentage num - size-percentage
#      // The default is something similar to "{1} / {2} ({3}) - {9}".
#    },
#    // {
#    //   "type": "battery",
#    //   "key": "Battery",
#    //   "temp": true,
#    // },
#    {
#      "type": "poweradapter",
#      "key": "{#90}{$1}│ {#91}Power       {#90}│",
#      "format": "{$2}{$3}{name}",
#      // fastfetch -h poweradapter-format
#      // {2}: PowerAdapter name - name
#      // The default is something similar to "{1}W".
#    },
#    {
#      "type": "terminal",
#      "key": "{#90}{$1}│ {#95}Terminal    {#90}│",
#      "format": "{$2}{$3}{pretty-name} {#2}[{version}] [PID:{pid}]",
#      // fastfetch -h terminal-format
#      // {5}: Terminal pretty name - pretty-name
#      // {6}: Terminal version - version
#      // The default is something similar to "{5} {6}".
#    },
#    {
#      "type": "terminalfont",
#      "key": "{#90}{$1}│ {#95}Font        {#90}│",
#      "format": "{$2}{$3}{name}  {#2}[{size}]",
#      // fastfetch -h terminalfont-format
#      // {2}: Terminal font name - name
#      // {3}: Terminal font size - size
#      // The default is something similar to "{1}".
#    },
#    {
#      "type": "shell",
#      "key": "{#90}{$1}│ {#95}Shell       {#90}│",
#      "format": "{$2}{$3}{pretty-name}  {#2}[v{version}] [PID:{pid}]",
#      // fastfetch -h shell-format
#      // {3}: Shell base name of arg0 - exe-name
#      // {4}: Shell version - version
#      // {5}: Shell pid - pid
#      // {7}: Shell full exe path - exe-path
#      // The default is something similar to "{3} {4}".
#    },
#    {
#      // localip IPv4
#      "type": "localip",
#      "key": "{#90}{$1}│ {#94}Local IPv4  {#90}│",
#      "showPrefixLen": true,
#      "showIpv4": true,
#      "showIpv6": false,
#      "showMtu": true,
#      "format": "{$2}{$3}{ifname}: {ipv4}  {#2}[MTU:{mtu}]",
#      // fastfetch -h localip-format
#      // {1}: Local IPv4 address - ipv4
#      // {4}: Interface name - ifname
#      // {6}: MTU size in bytes - mtu
#      // The default is something similar to "{1}".
#    },
#    {
#      // localip IPv6
#      "type": "localip",
#      "key": "{#90}{$1}│ {#94}Local IPv6  {#90}│",
#      "showPrefixLen": true,
#      "showIpv4": false,
#      "showIpv6": true,
#      "showMtu": true,
#      "format": "{$2}{$3}{ifname}: {ipv6}  {#2}[MTU:{mtu}]",
#      // fastfetch -h localip-format
#      // {2}: Local IPv6 address - ipv6
#      // {4}: Interface name - ifname
#      // {6}: MTU size in bytes - mtu
#      // The default is something similar to "{1}".
#    },
#    // {
#    //   "type": "dns",
#    //   "key": "DNS",
#    // },
#    {
#      "type": "publicip",
#      "key": "{#90}{$1}│ {#94}Public IPv4 {#90}│",
#      "format": "{$2}{$3}{ip}  {#2}[{location}]",
#      "ipv6": false,
#      // fastfetch -h publicip-format
#      // {1}: Public IP address - ip
#      // {2}: Location - location
#      // The default is something similar to "{1} ({2})".
#    },
#    {
#      "type": "publicip",
#      "key": "{#90}{$1}│ {#94}Public IPv6 {#90}│",
#      "ipv6": true,
#      "format": "{$2}{$3}{ip}  {#2}[{location}]",
#      // fastfetch -h publicip-format
#      // {1}: Public IP address - ip
#      // {2}: Location - location
#      // The default is something similar to "{1} ({2})".
#    },
#    // {
#    //   "type": "colors",
#    //   "symbol": "background",
#    // },
#    // CUSTOM - Button UI bar
#    {
#      "type": "custom",
#      "key": "{#90}{$1}╰─────────────╯",
#      "format": "{#90}{$2}╰────────────────────────────────────────────────────────────╯",
#    },
#  ],
#
