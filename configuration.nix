{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
  
    };

    initrd.luks.devices = [{
      name = "nixos";
      device = "/dev/sda3";
      preLVM = true;
    }];
  };

  time.timeZone = "America/New_York";

  networking = {
    hostName = "noir"; 
    useDHCP = false;
    # disable wpa_supplicant
    wireless.enable = false; 
    interfaceMonitor.enable = false;
    wicd.enable = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sudo
    wget
    lynx
    zsh
    tmux
    vim
    git
    gnupg
    pmutils
    sshfsFuse

    i3
    i3status
    dmenu
    xscreensaver

    pidgin
    pidginotr
    firefox
    keepassx
  ];

  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      liberation_ttf
      dejavu_fonts
      terminus_font
    ];
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "intel" "vesa" ];
      windowManager.i3.enable = true;
      windowManager.default = "i3"; 

      # suspend on lid close
      displayManager.desktopManagerHandlesLidAndPower = false;

      # set background and ssh-agent 
      displayManager.sessionCommands = ''
        xscreensaver -no-splash &
        eval $(cat .fehbg)
        eval $(ssh-agent)
      '';
    };
  };

  powerManagement = {
    enable = true;  
    powerDownCommands = "/run/current-system/sw/bin/slimlock";
  };

  hardware = {
    # middle click scrolling
    trackpoint.enable = true;
    trackpoint.emulateWheel = true;
  };

  users.extraUsers.wally = {
    name = "wally";
    group = "wheel";
    uid = 1000;
    createHome = true;
    home = "/home/wally";
    shell = "/run/current-system/sw/bin/zsh";
  };
}
