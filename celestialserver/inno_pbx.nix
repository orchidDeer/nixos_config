{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  environment.systemPackages = [ pkgs.virt-manager ];
  users.users.juna.extraGroups = [ "libvirtd" ];

  networking.nat.enable = true;
  networking.nat.externalInterface = "wlp4s0";
  networking.nat.forwardPorts = [
    {
      sourcePort = 8095;
      destination = "192.168.150.164:80";
      proto = "tcp";
    }
  ];

  services.caddy = {
    virtualHosts."http://dev-pbx.localdeer" = {
      extraConfig = ''
        reverse_proxy 192.168.150.164:80
      '';
    };

    virtualHosts."https://dev-pbx.localdeer" = {
      extraConfig = ''
        reverse_proxy 192.168.150.164:80
        tls internal
      '';
    };

    virtualHosts."http://dev-app.localdeer" = {
      extraConfig = ''
        reverse_proxy 192.168.150.165:80
      '';
    };

    virtualHosts."https://dev-app.localdeer" = {
      extraConfig = ''
        reverse_proxy 192.168.150.165:80
        tls internal
      '';
    };
  };

  /*
  virt-install \
    --name dev-pbx \
    --memory 1024 --vcpus 1 \
    --disk path=/home/juna/dev-pbx/uncompressed/ipva-disk1.vmdk,bus=ide \
    --disk path=/home/juna/dev-pbx/uncompressed/ipva-disk2.vmdk,bus=ide \
    --disk path=/home/juna/dev-pbx/uncompressed/ipva-disk3.vmdk,bus=ide \
    --disk path=/home/juna/dev-pbx/uncompressed/ipva-disk4.vmdk,bus=ide \
    --network network=default,model=vmxnet3 \
    --graphics vnc,listen=0.0.0.0 \
    --osinfo detect=on,require=off \
    --noautoconsole \
    --import

    virt-install \
      --name app-platform \
      --memory 2048 \
      --vcpus 2 \
      --disk path=/home/juna/inno/dev/app-platform/uncompressed/app-platform-disk1.vmdk,bus=scsi \
      --controller type=scsi,model=virtio-scsi \
      --network network=default,model=vmxnet3 \
      --graphics vnc,listen=0.0.0.0 \
      --osinfo detect=on,require=off \
      --noautoconsole \
      --import

    <network xmlns:dnsmasq='http://libvirt.org/schemas/network/dnsmasq/1.0'>
      <name>default</name>
      <uuid>ce2782e7-867e-4b33-89b0-13d1bf80297e</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:2f:a7:d2'/>
      <ip address='192.168.150.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.150.2' end='192.168.150.254'/>
          <host mac='52:54:00:0b:32:71' name='dev-pbx' ip='192.168.150.164'/>
          <host mac='52:54:00:e8:3e:2b' name='app-platform' ip='192.168.150.165'/>
        </dhcp>
      </ip>
      <dnsmasq:options>
        <dnsmasq:option value='dhcp-option=6,8.8.8.8,1.1.1.1'/>
        <dnsmasq:option value='port=0'/>
      </dnsmasq:options>
    </network>
  */
}
