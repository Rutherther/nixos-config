{ config, ... }:

{
  imports = [
    ./wg-options.nix
  ];

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    # disable auto resolving
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  networking.resolvconf.extraOptions = [
    "timeout: 2"
  ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "${config.wg.ip}/32" ];
      listenPort = 51820;

      generatePrivateKeyFile = true;
      privateKeyFile = "/etc/wireguard/pk.pem";

      peers = [
        {
          publicKey = "ZOVjmgUak67kLhNVgZwyb0bro3Yi4vCJbGArv+35IWQ=";
          endpoint = "78.46.201.50:51820";

            # The ip is not refreshed, as the kernel cannot perform DNS resolution. Use dynamicEndpointRefreshSeconds,
            # in case the ip is refreshed often. If not, sync after refresh should be alright.
          allowedIPs = [ "192.168.32.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
