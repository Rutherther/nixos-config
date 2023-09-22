{ config, lib, pkgs, user, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.nameservers = [
    "${inputs.semi-secrets.wg.lan.serverIp}"
    "1.1.1.1"
    "1.0.0.1"
  ];

  networking.resolvconf.extraOptions = [
    "timeout: 2"
  ];

  networking.wireguard.interfaces = {
    wg0 = {
      listenPort = 51820;

      generatePrivateKeyFile = true;
      privateKeyFile = "/home/${user}/.config/wireguard/pk.pem";

      peers = [
        {
          publicKey = "Mui5wOV21QTer4NK2dUcBOgaW9UFzFzwmxOn/458ByI=";
          endpoint = "${inputs.semi-secrets.wg.serverEndpoint}";
            # The ip is not refreshed, as the kernel cannot perform DNS resolution. Use dynamicEndpointRefreshSeconds,
            # in case the ip is refreshed often. If not, sync after refresh should be alright.
          allowedIPs = [ "${inputs.semi-secrets.wg.allowedIp}" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
