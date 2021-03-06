{ lib, stdenv
, fetchFromGitHub
, openssl_1_0_2
, zlib
, libssh
, cmake
, perl
, pkg-config
, rustPlatform
, curl
, libiconv
, CoreFoundation
, Security
}:

with rustPlatform;

buildRustPackage rec {
  pname = "git-dit";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "neithernut";
    repo = "git-dit";
    rev = "v${version}";
    sha256 = "1sx6sc2dj3l61gbiqz8vfyhw5w4xjdyfzn1ixz0y8ipm579yc7a2";
  };

  cargoSha256 = "1vbcwl4aii0x4l8w9jhm70vi4s95jr138ly65jpkkv26rl6zjiph";

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
  ];

  buildInputs = [
    openssl_1_0_2
    libssh
    zlib
  ] ++ lib.optionals (stdenv.isDarwin) [
    curl
    libiconv
    CoreFoundation
    Security
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Decentralized Issue Tracking for git";
    # This has not had a release in years and its cargo vendored dependencies
    # fail to compile. It also depends on an unsupported openssl:
    # https://github.com/NixOS/nixpkgs/issues/77503
    broken = true;
    license = licenses.gpl2;
    maintainers = with maintainers; [ Profpatsch matthiasbeyer ];
  };
}
