# create-puppet-manifest-from-jks
Create Puppet manifests from a Java keystore

## Usage

#### Running the script

./create_puppet_manifest_from_truststore -t TRUSTSTORE -p PASSWORD -c CLASSNAME

The class name parameter will indicate which path the class will have. For instance, if you wish for all of your trustore certificates to be used under profile::certs, then you would pass 'profile::certs' as the classname.

#### Using the output

Simply move the created .pp files to their appropriate path in your class.

To use them, pass a mandatory trustore, truststore password, and the directory where you wish the trusts should be written to. Additionally, you can also pass an optional alias.

Ex.

```puppet
::profile::cert::globalsign_organization_validation_ca_sha256_g2 {'my_important_app::globalsign_organization_validation_ca_sha256_g2':
  trustore   => 'my_import_app.jks',
  password   => 'password',
  trusts_dir => '/usr/local/src',
}
```

## Script output

The output will look like this.

```puppet
# Owner: CN=GlobalSign Organization Validation CA - SHA256 - G2, O=GlobalSign nv-sa, C=BE
# Issuer: CN=GlobalSign Root CA, OU=Root CA, O=GlobalSign nv-sa, C=BE
# Serial number: 40000000001444ef04247
# Valid from: Thu Feb 20 11:00:00 CET 2014 until: Tue Feb 20 11:00:00 CET 2024
# Certificate fingerprints:
# 	 MD5:  D3:E8:70:6D:82:92:AC:E4:DD:EB:F7:A8:BB:BD:56:6B
# 	 SHA1: 90:2E:F2:DE:EB:3C:5B:13:EA:4C:3D:51:93:62:93:09:E2:31:AE:55
# 	 SHA256: 74:EF:33:5E:5E:18:78:83:07:FB:9D:89:CB:70:4B:EC:11:2A:BD:23:48:7D:BF:F4:1C:4D:ED:50:70:F2:41:D9
define my_class::globalsign_organization_validation_ca_sha256_g2 (
    String $truststore,
    String $password,
    String $trusts_dir,
    String $aliasname = 'globalsign_organization_validation_ca_sha256_g2'
) {

    $cert_name = 'globalsign_organization_validation_ca_sha256_g2'

    $pem_file = @(END)
-----BEGIN CERTIFICATE-----
MIIEaTCCA1GgAwIBAgILBAAAAAABRE7wQkcwDQYJKoZIhvcNAQELBQAwVzELMAkG
A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jv
b3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xNDAyMjAxMDAw
MDBaFw0yNDAyMjAxMDAwMDBaMGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMTwwOgYDVQQDEzNHbG9iYWxTaWduIE9yZ2FuaXphdGlvbiBW
YWxpZGF0aW9uIENBIC0gU0hBMjU2IC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDHDmw/I5N/zHClnSDDDlM/fsBOwphJykfVI+8DNIV0yKMCLkZc
C33JiJ1Pi/D4nGyMVTXbv/Kz6vvjVudKRtkTIso21ZvBqOOWQ5PyDLzm+ebomchj
SHh/VzZpGhkdWtHUfcKc1H/hgBKueuqI6lfYygoKOhJJomIZeg0k9zfrtHOSewUj
mxK1zusp36QUArkBpdSmnENkiN74fv7j9R7l/tyjqORmMdlMJekYuYlZCa7pnRxt
Nw9KHjUgKOKv1CGLAcRFrW4rY6uSa2EKTSDtc7p8zv4WtdufgPDWi2zZCHlKT3hl
2pK8vjX5s8T5J4BO/5ZS5gIg4Qdz6V0rvbLxAgMBAAGjggElMIIBITAOBgNVHQ8B
Af8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUlt5h8b0cFilT
HMDMfTuDAEDmGnwwRwYDVR0gBEAwPjA8BgRVHSAAMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDMGA1UdHwQsMCow
KKAmoCSGImh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5uZXQvcm9vdC5jcmwwPQYIKwYB
BQUHAQEEMTAvMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNv
bS9yb290cjEwHwYDVR0jBBgwFoAUYHtmGkUNl8qJUC99BM00qP/8/UswDQYJKoZI
hvcNAQELBQADggEBAEYq7l69rgFgNzERhnF0tkZJyBAW/i9iIxerH4f4gu3K3w4s
32R1juUYcqeMOovJrKV3UPfvnqTgoI8UV6MqX+x+bRDmuo2wCId2Dkyy2VG7EQLy
XN0cvfNVlg/UBsD84iOKJHDTu/B5GqdhcIOKrwbFINihY9Bsrk8y1658GEV1BSl3
30JAZGSGvip2CTFvHST0mdCF/vIhCPnG9vHQWe3WVjwIKANnuvD58ZAWR65n5ryA
SOlCdjSXVWkkDoPWoC209fN5ikkodBpBocLTJIg1MGCUF7ThBCIxPTsvFwayuJ2G
K1pp74P1S8SqtCr4fKGxhZSM9AyHDPSsQPhZSZg=
-----END CERTIFICATE-----
    END

    ensure_resource('file', "${trusts_dir}/${cert_name}.pem", {
      'ensure'  => 'file',
      'content' => $pem_file
    })

    java_ks {"${name}::${cert_name}":
        ensure      => latest,
        name        => $aliasname,
        certificate => "${trusts_dir}/${cert_name}.pem",
        target      => $truststore,
        password    => $password,
        require     => File["${trusts_dir}/${cert_name}.pem"],
    }

}
```

## Requires

- Perl
