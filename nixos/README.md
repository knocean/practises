# NixOS

Nix is a package manager for Linux and macOS with many characteristics of a functional programming language.
NixOS is a Linux distribution built on Nix.
The key benefits are declarative configuration and fully reproducible environments.

## Links

- [Nix Package Manager Manual](https://nixos.org/nix/manual/)
- [NixOS Manual](https://nixos.org/nixos/manual/)
- [Search Nix Packages](https://nixos.org/nixos/packages.html)
    - Search with `!nixpkgs` in [DuckDuckGo](https://duckduckgo.com)
- [Search NixOS options](https://nixos.org/nixos/options.html)
    - Search with `!nixopts` in [DuckDuckGo](https://duckduckgo.com)
- [GitHub](https://github.com/NixOS/nixpkgs)
- [Nix Pills tutorial](https://nixos.org/nixos/nix-pills/index.html)

## macOS

Nix works on macOS, and I prefer it to Homebrew.
Unfortunately macOS Catalina locked down the root directories,
requiring some annoying workarounds:
[#2925](https://github.com/NixOS/nix/issues/2925#issuecomment-539570232)

## Amazon EC2

There are official, public AMIs for NixOS:
[ec2-amis.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/ec2-amis.nix)

## nix-channel

Nix versions packages according to "channels".
There's a cutting edge `unstable` channel.
A new dated channel is released in the spring and the fall.

For my laptop I use the latest `nixpkgs` `unstable`:

```shell
$ sudo su
# nix-channel --list
nixpkgs https://nixos.org/channels/nixpkgs-20.03-darwin
# nix-channel --update
```

For servers I use the most recent dated channel,
allowing it to automatically update,
then migrating to the new dated channel when it's released.
Migration is usually painless.

- `nix-channel --list`
- `nix-channel --update`
- `nix-channel --remove nixos`
- `nix-channel --add nixos https://nixos.org/channels/nixos-20.03`

## nix-env

To install packages for a user, use `nix-env`:

- `nix-env -q` list installed packages
- `nix-env -q foo` search installed packages for "foo"
- `nix-env -qa '.*foo.*'` search available packages on your channels
- `nix-env -qc` compare installed packages to available packages
- `nix-env -i foo` install package
- `nix-env -u foo` upgrade package
- `nix-env -u` upgrade installed packages
- `nix-env -e foo` uninstall package

I use `nix-env` for a very small set of packages,
and `nix-shell` for project-specific dependencies.

## nix-shell

To install a package temporarily, use `nix-shell`:

```shell
$ nix-shell -p dos2unix
[nix-shell:~]#
```

For each project I create a `shell.nix` file then just run `nix-shell`:

```nix
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-environment";

  buildInputs = [
    jre8_headless
  ];
}
```

The `shellHook` option is useful:

```nix
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-environment";

  buildInputs = [
    python37Packages.virtualenv
  ];
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    virtualenv _venv
    source _venv/bin/activate
    pip install -r requirements.txt
  '';
}
```

## Utilities

- `nix-collect-garbage` to remove unused stuff from the `/nix/store`

## /etc/nixos/configuration.nix

NixOS systems are configured declaratively with a
[`configuration.nix`](configuration.nix) file.
When you make changes, run `nixos-rebuild`:

- `nixos-rebuild test` test your new configuration
- `nixos-rebuild switch` rebuild and use the new configuration
- `nixos-rebuild switch --upgrade` update the channel, rebuild, and switch
- `nixos-rebuild switch --rollback` revert to the previous configuration

A basic `configuration.nix` for an EC2 instance might look like this:

```nix
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-20.03;

  networking.hostName = "dev";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "America/Toronto";

  users.extraUsers.james =
  { isNormalUser = true;
    home = "/home/james";
    description = "James A. Overton";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # ...
    ];
  };

  # ...
}
```

## nginx

I really like the declarative configuration for web servers:

```nix
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "knotation.org" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/knotation/knotation.org/";
      };
      "fiddle.knotation.org" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:8000/";
      };
    };
  };
}
```

With `enableACME = true;` you get a free
[Let's Encrypt SSL certificate](https://letsencrypt.org),
automatically updated every three months.
Let's Encrypt will check your server to ensure that you own the domain,
so make sure that your DNS is configured before running this.

## Systemd

A basic `systemd` wrapper for a `run.sh` script can look like this:

```nix
{
  systemd.services."knocean.droid" = {
    enable = true;
    description = "DROID";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "root";
      ExecStart = "/run/wrappers/bin/su -lmc /var/www/droid/run-droid.sh";
      Restart = "always";
    };
  };
}
```

Then create a `run.sh` script with any secrets, and `chmod 700 run.sh`:

```shell
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash jre8_headless
trap 'exit 0' 1 2 15
source settings.env
java -jar /var/www/droid/target/uberjar/droid-0.1.0-SNAPSHOT-standalone.jar
```

Add dependencies to the second line.
The `trap` allows for a cleaner restart from `systemd`.

## Abstractions

All this configuration is written in the
[Nix expression language](https://nixos.org/nix/manual/#ch-expression-language)
which has some basic tools for
[abstractions](https://nixos.org/nixos/manual/index.html#sec-module-abstractions).
I like these [examples](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55).

A good pattern seems to be:

```nix
let
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
in {
  services.nginx.virtualHosts = apply makeVirtualHost webServices;
}
```

You can test this with `nix-instantiate`:

```shell
$ nix-instantiate --eval --strict example.nix
{ services = { nginx = { virtualHosts = { "editor.obolibrary.org" = { enableACME = true; forceSSL = true; locations = { "/" = { proxyPass = "http://127.0.0.1:5001/"
; }; }; }; }; }; }; }
```

which cleans up to what we would have written by hand:

```nix
{
  services.nginx.virtualHosts."editor.obolibrary.org" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:5001/";
  };
}
```

## Containers

NixOS has very nice tools for lightweight
[containers](https://nixos.org/nixos/manual/index.html#ch-containers).
Add this to `configuration.nix` to enable container
[networking](https://nixos.org/nixos/manual/index.html#sec-container-networking)

```nix
{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "eth0";
}
```

Running `nixos-container create foo` will
put a bit of config in `/etc/containers/foo.conf`, and
put a full (small) NixOS system in `/var/lib/containers/foo`,
including an `etc/nixos/configuration.nix`.
If you tweak the configuration, run `nixos-container update foo` to rebuild.

```shell
nixos-container start foo
nixos-container run foo -- echo "Bar!"
nixos-container root-login foo
nixos-container login foo
nixos-container run foo -- su droid -c "cd /droid && make bar"
```

One gotcha: container names are limited to 11 characters!
