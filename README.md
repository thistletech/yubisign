# YubiKey File Signing

[![Shellcheck](https://github.com/thistletech/yubisign/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/thistletech/yubisign/actions/workflows/shellcheck.yml)
[![Markdown Lint](https://github.com/thistletech/yubisign/actions/workflows/markdownlint.yml/badge.svg)](https://github.com/thistletech/yubisign/actions/workflows/markdownlint.yml)

`yubisign` is a wrapper around [pivit](https://github.com/cashapp/pivit), aiming
at ease-of-use for file signing.

## Install Dependencies

### Install Go

Download and install Go following these
[instructions](https://go.dev/doc/install), or install Go using your OS
distribution's package manager.

### Install `pivit`

- Install `pivit` dependencies.

  - On macOS, no additional packages are needed for building and running `pivit`.

  - On Debian-based Linux distributions (e.g., Ubuntu):

    ```bash
    sudo apt install libpcsclite-dev pcscd
    ```

  - On NixOS,

    ```bash
    nix-shell -p pcsclite pkg-config
    ```

- Build and install `pivit`

  ```bash
  # Install pivit v0.2.0. Pin commit because it's less malleable than a tag
  go install github.com/cashapp/pivit/cmd/pivit@c90a8ab2466343faa0241fd2106992d14dfd5310
  ```

Add `$GOPATH/bin` to your `PATH` environment variable so the `pivit` command
will be readily available. Alternatively, one may also set the environment
variable `THISTLE_PIV` to override the path of the `pivit` binary.

## Use `yubisign` to Manage `pivit` Keys

- Clone this repository and change to it

  ```bash
  git clone https://github.com/thistletech/yubisign.git
  cd yubisign
  ```

- (One-time operation) Generate a new key pair

  ```bash
  thistle-bin/yubisign keygen
  ```

  The leaf certificate associated with the private key generated inside the
  YubiKey hardware is printed to `stdout`. By default, the leaf certificate
  file, and the PIV attestation certificate file, which issues the leaf
  certificate, are saved to the `./.certs` directory. The output directory path
  for these certificates can be overridden by setting environment variable
  `THISTLE_CERTS_OUTDIR`. The YubiKey PIV root CA certificate that issues the
  PIV attestation certificate is
  [data/piv-attestation-ca.pem](data/piv-attestation-ca.pem)
  (sha256sum:6234f33d5f652109d265b391f2898b8ba92f62df406b684db18363f50d7c9129),
  obtained from
  <https://developers.yubico.com/PIV/Introduction/piv-attestation-ca.pem>.

- Sign a file using the key generated in YubiKey

  If signing is successful, the signature is printed out to stdout, in both PEM
  format (surrounded by "PKCS7" header and footer). Note that the PEM content is
  the DER content base64 encoded.

  ```bash
  # Example
  $ thistle-bin/yubisign sign /path/to/payload_file
  -----BEGIN PKCS7-----
  MIID2wYJKoZIhvcNAQcCoIIDzDCCA8gCAQExDTALBglghkgBZQMEAgEwCwYJKoZI
  hvcNAQcBoIICdjCCAnIwggFaoAMCAQICEAGgZsOXvEIKrY6EOAnPShgwDQYJKoZI
  hvcNAQELBQAwITEfMB0GA1UEAwwWWXViaWNvIFBJViBBdHRlc3RhdGlvbjAgFw0x
  NjAzMTQwMDAwMDBaGA8yMDUyMDQxNzAwMDAwMFowJTEjMCEGA1UEAwwaWXViaUtl
  eSBQSVYgQXR0ZXN0YXRpb24gOWUwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAASwqZBV
  DUCS9DKzwjXxDKKWzBPgVIyssm87/FdwENjyTUh4gMC2jHjxnl1OHmUZ2u6KB5Yh
  ZT2cF+dyXOImiPLMclS6IB+Ut1KIAhTUS+SjfoKL8rMSTVP9KTUBW2zWYymjTjBM
  MBEGCisGAQQBgsQKAwMEAwUCBzAUBgorBgEEAYLECgMHBAYCBAD0AjQwEAYKKwYB
  BAGCxAoDCAQCAQIwDwYKKwYBBAGCxAoDCQQBAzANBgkqhkiG9w0BAQsFAAOCAQEA
  TGTSA4RUfXqAbhGExJ4/EWAHQ9cPkWqaVm28G2axpPRcjTUcGERqWu0xuov1d6k0
  oCm4S8u3y7jD6FZMbQELjMbqpQs8wDwypQF0ul1vhvqXZKHXUnQtyvvXt0iyhL9+
  mjFQkyiI1OB7Js7xOKtm9SiiCjP65XAWkPq6Su2cQgzlIi0sMhWAvEf/a8n3VWxt
  lgFtnWlMPcByf/bDhprj8KY8QNJPxkFbrDOOE/8fyGsWb+VKMbNGym8xEPQCCdnj
  KQ0VfTNND1dU2wgzmSEiaOvs2SwqD46wt7+uX2eJjpAWi/cSWlg790P5Q8r2OdgS
  BLGqfaUtfn0VZD+8S3oM4jGCASswggEnAgEBMDUwITEfMB0GA1UEAwwWWXViaWNv
  IFBJViBBdHRlc3RhdGlvbgIQAaBmw5e8QgqtjoQ4Cc9KGDALBglghkgBZQMEAgGg
  aTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjEx
  MTUxNzEzMjVaMC8GCSqGSIb3DQEJBDEiBCC3rz/0lMiRLhrcPzoW1G7UOGy2yVXQ
  exwxxmxj06NmxTAKBggqhkjOPQQDAgRnMGUCMQDXVh2RcT4h2R5hRC8Rwem+0ZJ/
  gMlGe9OAGZSi2ZDBK3dRdDr2iEdJW/UoWye5o8MCMA/X9h3+kVgApGl1Wlewdm2k
  IgGjtWSYwBsMxD/sxnvCtxUfOk1UsY8G3JZuR9NuqQ==
  -----END PKCS7-----
  ```

  The signature in PEM format can be extracted with

  ```bash
  thistle-bin/yubisign sign /path/to/payload_file | \
    awk '/^-----BEGIN PKCS7-----/,/^-----END PKCS7-----/{print}' > /path/to/sig.pem
  ```

  The detached signature in PEM format is output to `/path/to/sig.pem`.

## Verify certificates and signatures

- Verify that leaf certificate is indeed generated inside YubiKey hardware
  against the PIV attestation certificate and the PIV root CA certificate, using
  `openssl`

  ```bash
  $ openssl verify -CAfile data/piv-attestation-ca.pem \
    -untrusted .certs/piv_attestation.pem \
    .certs/leaf.pem
  # Upon verification success
  .certs/leaf.pem: OK
  ```

- Verify signature against leaf certificate using `openssl`, where
  `/path/to/payload_file`, `/path/to/sig.pem`, and `.certs/leaf.pem` are the
  payload file, the signature file, and the leaf certificate, respectively.

  ```bash
  # Verify sig.pem against leaf.pem. The `-nointern` option does not use the
  # signer certificate included in sig.pem for signature verification, but uses
  # leaf.pem instead. Also use leaf.pem as untrusted CA.
  $ openssl smime -verify -binary -content /path/to/payload_file \
    -in /path/to/sig.pem -inform PEM \
    -certfile .certs/leaf.pem -nointern \
    -CAfile .certs/leaf.pem -partial_chain
  # Upon verification success
  [...]
  Verification successful
  $ echo $?
  0
  ```

  The above signature verification step is also implemented by the `verify`
  subcommand of `yubisign`, with the signature and certificate files in
  base64 encoded DER format.

  ```bash
  thistle-bin/yubisign verify /path/to/payload_file \
    /path/to/signature.b64 /path/to/leaf_cert.b64
  ```

## Synopsis

```bash
# thistle-bin/yubisign -h
Usage: ./thistle-bin/yubisign <subcommand> [options]

Subcommands:
  keygen  Generate new YubiKey keypair for signing
  sign    Sign a file with YubiKey
  verify  Verify a YubiKey signature with a certificate

For subcommand usage, run:
  thistle-bin/yubisign <subcommand> -h|--help
```

Subcommands

```bash
# thistle-bin/yubisign keygen -h
Usage:
  thistle-bin/yubisign keygen -h    Display this help message
  thistle-bin/yubisign keygen [-v]
           Generate a new key pair in YubiKey for release signing.
           When -v is present, output debugging information.
```

```bash
# thistle-bin/yubisign sign -h
Usage:
  thistle-bin/yubisign sign -h    Display this help message
  thistle-bin/yubisign sign [-v] PAYLOAD_FILE
           Sign PAYLOAD_FILE with YubiKey.
           When -v is present, output debugging information.
```

```bash
# thistle-bin/yubisign verify -h
Usage:
  thistle-bin/yubisign verify -h    Display this help message
  thistle-bin/yubisign verify [-v] PAYLOAD_FILE SIGNATURE_FILE CERTIFICATE_FILE
           Verify SIGNATURE_FILE for PAYLOAD_FILE using CERTIFICATE_FIlE, using openssl.
           SIGNATURE_FILE AND CERTIFICATE_FILE are base64-encoded DER formatted data.
           When -v is present, output debugging information.
```
