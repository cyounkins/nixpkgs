{ stdenv, fetchFromGitHub, m4 }: 

stdenv.mkDerivation rec {
  name = "nvidia-modprobe-${version}";
  version = "415.18";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = "023a7acb690314f0f55f2640a3d45c63106760d8";
    sha256 = "1c4p2c5sls7xyrfpz7c5sxcknzq1yypzag59n17b0nbcxsfh1hc0";
  };

  nativeBuildInputs = [ m4 ];

  makeFlags = [
    "PREFIX=$(out)"
    "OUTPUTDIR=$(out)"
    "OUTPUTDIR_ABSOLUTE=$(out)"
  ];

  postInstall = ''
    cd modprobe-utils

    mkdir -p $out/include
    for filename in *.h; do
      install -m 644 $filename $out/include/$filename
    done

    mkdir -p $out/lib
    for filename in *.a; do
      install -m 644 $filename $out/lib/$filename
    done
  '';
}

