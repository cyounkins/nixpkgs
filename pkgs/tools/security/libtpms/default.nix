{ lib
, stdenv
, fetchFromGitHub
, pkg-config, autoreconfHook
, openssl, perl
}:

stdenv.mkDerivation rec {
  pname = "libtpms";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "v${version}";
    sha256 = "sha256-D6lYOVlgtBY6C07YqbG6TPnDKrUoEj82Ra6GK/HB7X8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl # needed for pod2man
  ];
  buildInputs = [ openssl ];

  outputs = [ "out" "man" "dev" ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-openssl"
    "--with-tpm2"
  ];

  meta = with lib; {
    description = "The libtpms library provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = "https://github.com/stefanberger/libtpms";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
