{
  modulesPath,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../sys/tty.nix
    ../sys/aliases.nix
    ../sys/nix.nix
    ../sys/cache.nix

    ../services/journald.nix
    ../services/net/nginx.nix
    ../services/net/sshd.nix
    ../services/databases/postgresql.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    fzf
    gitMinimal
    curl
    curlie
    bottom
    ncdu
    rsync
    zoxide
    bat
    tealdeer
  ];

  users.users.kh = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNXlGGqBaG3wXy235NZcgG1prg6LE4H2Rajno5Srx+9rQ20FL/sXxfqJAYcCxoj1KeUGWxfBhv0P8qlfv9SFatOeZKsGb6uW8n4zEg4vktgboJ//VPrLGRo3V9+7rQ5EqrK5JBUah3K1WJv4rIGAIu2kWAsEmhnHIpazw9EcQdBsLG98dYBSOerXXwepR31fKJM9aDb4G+AiS2bW/zHhDlUFnZPuCEhsK1RcZqeNW6l3pMfxqK/t1U9xXqxBPjKE8xyleTE5NhYBi9IWh28+dkY9PC8Uj7/T3yon3Axvh6gV9wuk58T/4GeQkpCmtnsTgR3tFULHiXrrHCqszLa5QiEe8EowQiQVyX6iYg//EEyE4fejsijGvcDC7o9Vf9MJYBuSPQyXKK3koayK+t0N7i7u1kp0yLU4rCTWXnqEKa6ksBki7s57hmv0+cR1fMTqFctSUwn1x7ozxfUizunZIP3EtJIq1X65nqd83uA3vORTo6cBVG8W8mvunnsG+tkUtkUU7VSmPhi/7DwFx1l46fgd1DmU3CXI/rk6oaPBvGX063xTZZb1dg0lOhRlVmKNZp6ZwfNp1W0GJqQ1rAQWmfGQMPFOuahOJdjXe6OzPavXAPcUw32avP8C895MY8kTMGbaCPtJ7MCCCbWgf0hT4uaDaLQYgIVPi55OTevY8+vQ== kh@laundry"
    ];

    initialHashedPassword = "$y$j9T$H52H7Xta1XhESYb2vE07C/$diE1gF.OIIOCBo6jzKATasjiKwXKhbLCEWmJd.PBZM1";
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNXlGGqBaG3wXy235NZcgG1prg6LE4H2Rajno5Srx+9rQ20FL/sXxfqJAYcCxoj1KeUGWxfBhv0P8qlfv9SFatOeZKsGb6uW8n4zEg4vktgboJ//VPrLGRo3V9+7rQ5EqrK5JBUah3K1WJv4rIGAIu2kWAsEmhnHIpazw9EcQdBsLG98dYBSOerXXwepR31fKJM9aDb4G+AiS2bW/zHhDlUFnZPuCEhsK1RcZqeNW6l3pMfxqK/t1U9xXqxBPjKE8xyleTE5NhYBi9IWh28+dkY9PC8Uj7/T3yon3Axvh6gV9wuk58T/4GeQkpCmtnsTgR3tFULHiXrrHCqszLa5QiEe8EowQiQVyX6iYg//EEyE4fejsijGvcDC7o9Vf9MJYBuSPQyXKK3koayK+t0N7i7u1kp0yLU4rCTWXnqEKa6ksBki7s57hmv0+cR1fMTqFctSUwn1x7ozxfUizunZIP3EtJIq1X65nqd83uA3vORTo6cBVG8W8mvunnsG+tkUtkUU7VSmPhi/7DwFx1l46fgd1DmU3CXI/rk6oaPBvGX063xTZZb1dg0lOhRlVmKNZp6ZwfNp1W0GJqQ1rAQWmfGQMPFOuahOJdjXe6OzPavXAPcUw32avP8C895MY8kTMGbaCPtJ7MCCCbWgf0hT4uaDaLQYgIVPi55OTevY8+vQ== kh@laundry"
      ];
    };
  };
  users.defaultUserShell = pkgs.fish;

  # sudo ip route add 10.0.0.1 dev ens3
  # sudo ip address add 212.109.193.139/32 dev ens3
  # sudo ip route add default via 10.0.0.1 dev ens3
  networking = {
    useDHCP = false;
    hostName = "frakurai";
    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "149.154.65.106";
            prefixLength = 32;
          }
        ];

        ipv4.routes = [
          {
            address = "10.0.0.1";
            prefixLength = 32;
          }
        ];
      };
    };

    nameservers = ["8.8.8.8" "8.8.4.4"];
    defaultGateway = "10.0.0.1";
  };

  system.stateVersion = "24.05";
  documentation.nixos.enable = false;

  # apps
  services.nginx.virtualHosts."todo.frakurai.ru" = {
    forceSSL = true;
    enableACME = true;

    root = inputs.todo-vue.packages.x86_64-linux.default;

    extraConfig = ''
      location / {
        try_files $uri $uri/ /index.html;
      }
    '';
  };
}
