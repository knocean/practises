{ config, pkgs, ... }:
let
  # Define various web services as nginx proxyPass and systemd services.
  webServices = [
    { name = "editor.obolibrary.org"; port = "5001"; }
  ];

  apply = func: list: (builtins.listToAttrs (map func list));
  makeVirtualHost = { name, port }: {
    name = name;
    value = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:${port}/";
    };
  };
  makeSystemdService = { name, port }: {
    name = "knocean-${name}";
    value = {
      enable = true;
      description = name;
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PORT = port;
      };
      serviceConfig = {
        User = "root";
        WorkingDirectory = "/var/www/${name}";
        ExecStart = "/run/wrappers/bin/su -lmc /var/www/${name}/run.sh";
        Restart = "always";
      };
    };
  };
in
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  system.autoUpgrade.channel = https://nixos.org/channels/nixos-20.03;
  system.autoUpgrade.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    # ...
  ];

  environment.systemPackages = [
    pkgs.mosh
    pkgs.tmux
    pkgs.git
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.nginx.virtualHosts = apply makeVirtualHost webServices;

  systemd.services = apply makeSystemdService webServices;
}
