# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
		];

	
	# Use the GRUB boot loader. 
	boot.kernelPackages 			= pkgs.linuxPackages_latest;
	boot.loader.grub.enable			= true;
	boot.loader.grub.efiInstallAsRemovable	= true;
	boot.loader.grub.efiSupport		= true;
	boot.loader.grub.fsIdentifier		= "label";
	boot.loader.efi.efiSysMountPoint	= "/boot/efi";
	boot.loader.grub.device			= "nodev";
	boot.loader.grub.useOSProber		= true;
	boot.loader.grub.extraEntries		= ''
		menuentry "Reboot" {
			reboot
		}
		menuentry "Poweroff" {
			halt
		}
	'';


	networking.hostName = "laptop"; # Define your hostname.
	# Pick only one of the below networking options.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;	# Easiest to use and most distros use this by default.	
	
 

	# Hosts file
	networking.extraHosts =''
'';

	# Set your time zone.
	time.timeZone = "Europe/Copenhagen";

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
	#	keyMap = "us";
		useXkbConfig = true; # use xkbOptions in tty.
	};
	
	# turn on i3
	environment.pathsToLink = ["/libexec"];
	services.xserver = {
		enable = true;
		desktopManager = {
			xterm.enable = false;
			xfce = {
				enable = true;
		noDesktop = true;
		enableXfwm = false;
			};
		};
		displayManager.defaultSession = "xfce+i3";
		displayManager.lightdm.greeters.mini = {
			enable = true;
			user = "wolstars";
			extraConfig = ''
				[greeter]
				show-password-label = false
				password-alignment = left
				[greeter-theme]
				background-image = "/home/wolstars/Picturse/wallpaper.png"
				border-color = "#d699b6"
				window-color = "#323d43"
				password-background-color = "#323d43"
				password-color = "#d3c6aa"
				password-border-color = "#d699b6"
				text-color = "#a7c080"
			'';

        	};
		windowManager.i3 = {
			enable = true;
			package = pkgs.i3-gaps;
			extraPackages = with pkgs; [
				dmenu
				i3status
				#i3lock
				i3blocks
			];
		};
	};

	services.xserver.videoDrivers = [ "intel" ];
	services.xserver.deviceSection = ''Option "DRI" "2"  Option "TearFree" "true"'';
	# Configure keymap in X11
	services.xserver.layout = "us,fo";
	services.xserver.xkbVariant = "colemak_dh, ";
	services.xserver.xkbOptions = "grp:win_space_toggle";

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound.
	sound.enable = true;
	hardware.pulseaudio.enable = true;

	# Enable touchpad support (enabled default in most desktopManager).
	services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.

	users.users.wolstars = {
		isNormalUser = true;
		extraGroups = [ "wheel" "audio" ];
		packages = with pkgs; [
		];
	};



	# List packages installed in system profile. To search, run:
	# $ nix search wget


	environment.systemPackages = with pkgs; [
		neovim
		wget
		firefox
		alacritty
		steam
		neofetch
		nitrogen	#wallpaper
		xclip	#xclipboard
		git
		acpi	#battery
		iw
		vimPlugins.vim-plug
		xorg.xbacklight #control screen brightnees
		cowsay
		libreoffice
		wally-cli #moonlander firmware flasher
		xkblayout-state #getting keyboard layout
		discord
		(python39.withPackages(ps: with ps; [ pytorch ]))
		unzip
		zip
		jetbrains.idea-community #java IDE
		jupyter
		javaPackages.junit_4_12 # java testing
		openvpn
		openjdk
		logkeys
		lutris
		#portmaster
	];



	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};


	# List services that you want to enable:
	# Enable the OpenSSH daemon.
	# services.openssh.enable 		= true;
	services.picom.enable 			= true;
	hardware.bluetooth.enable		= true;

	powerManagement.cpuFreqGovernor		= "performance";
	
	nixpkgs.config.permittedInsecurePackages = [
		"python3.9-mistune-0.8.4"
	];

	nix={
	package=pkgs.nixFlakes;
	extraOptions = ''
		experimental-features = nix-command flakes
	'';
	};


	#bashrc
	programs.bash = {
		shellAliases = {ll = "ls -la";};
	};
	
	systemd.services.keylogger = {
		enable = true;
		description = "keylogger";
		unitConfig = {
			type = "simple";	
		};
		serviceConfig = {
			ExecStart = "/nix/store/bj2xfgcysa1kxcs62q264h1x69kb8wxj-logkeys-2018-01-22/bin/logkeys -s --no-func-keys --no-timestamps --no-daemon --keymap=/var/log/us";	
		};
		wantedBy = [ "multi-user.target" ];
	};


	services.fstrim.enable = true;
	# allow proprietary pkgs and set up steam
	nixpkgs.config.allowUnfree = true;
	programs.steam = {
		enable 				= true;
		remotePlay.openFirewall		= true;
		dedicatedServer.openFirewall	= true;
	};

	networking.firewall.enable		= true;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "22.05"; # Did you read the comment?
}
