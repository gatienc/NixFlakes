{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  lowBatteryNotify = pkgs.writeShellScript "low-battery-notify" ''
    #!/usr/bin/env bash
    
    # Allow testing by passing a threshold as first argument (default: 5)
    THRESHOLD=''${1:-5}
    
    # Get battery status
    BATTERY_PATH="/sys/class/power_supply/BAT0"
    
    # Check if battery exists
    if [ ! -d "$BATTERY_PATH" ]; then
      BATTERY_PATH="/sys/class/power_supply/BAT1"
    fi
    
    if [ ! -d "$BATTERY_PATH" ]; then
      exit 0
    fi
    
    # Read battery info
    CAPACITY=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)
    STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null)
    
    # Check if values were read successfully
    if [ -z "$CAPACITY" ] || [ -z "$STATUS" ]; then
      exit 0
    fi
    
    # Send notification if battery is below threshold and discharging
    if [ "$CAPACITY" -le "$THRESHOLD" ] && [ "$STATUS" = "Discharging" ]; then
      ${pkgs.dunst}/bin/dunstify \
        -u critical \
        -r 9999 \
        -h "int:value:$CAPACITY" \
        "Battery Critical" \
        "Battery is at $CAPACITY%! Please plug in your charger."
    fi
  '';
in
{
  # Power management for better battery life
  # Disable power-profiles-daemon as it conflicts with auto-cpufreq
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  boot.kernelParams = [ "button.lid_init_state=open" ];
  
  programs.xss-lock = {
    enable = true;
    lockerCommand = "systemctl suspend";
  };

  # Low battery notification service
  systemd.user.services.low-battery-notify = {
    description = "Low battery notification";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lowBatteryNotify;
    };
  };

  systemd.user.timers.low-battery-notify = {
    description = "Timer for low battery notification";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "2min";
      Unit = "low-battery-notify.service";
    };
  };

  # Add the script to system packages so it can be run manually for testing
  environment.systemPackages = [ 
    (pkgs.writeShellScriptBin "low-battery-test" ''
      #!/usr/bin/env bash
      # Test the notification by simulating a low battery condition
      
      echo "Testing low battery notification..."
      
      # Send a test notification with current battery info
      BATTERY_PATH="/sys/class/power_supply/BAT0"
      if [ ! -d "$BATTERY_PATH" ]; then
        BATTERY_PATH="/sys/class/power_supply/BAT1"
      fi
      
      if [ -d "$BATTERY_PATH" ]; then
        CAPACITY=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)
        STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null)
        ${pkgs.dunst}/bin/dunstify \
          -u critical \
          -r 9999 \
          -h "int:value:''${CAPACITY:-0}" \
          "Battery Test" \
          "Current: ''${CAPACITY:-N/A}%, Status: ''${STATUS:-N/A}"
      else
        ${pkgs.dunst}/bin/dunstify \
          -u critical \
          -r 9999 \
          "Battery Test" \
          "No battery found - but notification works!"
      fi
    '')
  ];
}
