{
  networking.hostName = "celestia";
  # Enable networking
  networking.networkmanager.enable = true;

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIBozCCAUmgAwIBAgIQBpzf7y1Y1F/xOtSJJ3EQWzAKBggqhkjOPQQDAjAwMS4w
      LAYDVQQDEyVDYWRkeSBMb2NhbCBBdXRob3JpdHkgLSAyMDI2IEVDQyBSb290MB4X
      DTI2MDYyNzIxMTgxN1oXDTM2MDUwNTIxMTgxN1owMDEuMCwGA1UEAxMlQ2FkZHkg
      TG9jYWwgQXV0aG9yaXR5IC0gMjAyNiBFQ0MgUm9vdDBZMBMGByqGSM49AgEGCCqG
      SM49AwEHA0IABIZh/+4qLivG5W5OCxxzoRJCoDh9qqLxq/Xzgtl+OKd8Vbo7vHdB
      dlvYk0Ke3Gdxjn9wKfW2jLG3KqC70MlfPkyjRTBDMA4GA1UdDwEB/wQEAwIBBjAS
      BgNVHRMBAf8ECDAGAQH/AgEBMB0GA1UdDgQWBBSqtqaBU9lCYXCtSm9KQuT/3PzA
      7jAKBggqhkjOPQQDAgNIADBFAiEA4jRQkJNhcLnBIQFfyuG5DOp8YsVAZ3Tl03rI
      qUh39w8CIEtydghiprfmh1qhIWVa9qUhKSJckvVMSyookxDTFz3L
      -----END CERTIFICATE-----
    ''
  ];

}
