{ stdenv, fetchFromGitHub, fetchurl, libcap, libelf, libseccomp }:

stdenv.mkDerivation rec {
  name = "libnvidia-container-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libnvidia-container";
    rev = "deccb2801502675bd283c6936861814dbca99ecd";
    sha256 = "12fwa985gxmzq42c9ha5wz0z4anlqq8a4ij7rc0w0f4gmqqfwpf2";
  };

  srcStatic = fetchurl {
    url = "https://github.com/NVIDIA/nvidia-modprobe/archive/396.51.tar.gz";
    sha256 = "082b1jvkg1dij6l7yvmi7vi1fdbmp7jw4snpkw76ggl4lcvn9g15";
  };

  buildInputs = [ libcap libelf libseccomp ];

  makeFlags = [
    "WITH_LIBELF=yes"
    "DESTDIR=$(out)"
    "prefix=/"
  ];

  preBuild = ''
    sed -i 's/^REVISION :=.*/REVISION = ${src.rev}/' mk/common.mk
    sed -i 's/^COMPILER :=.*/COMPILER = $(CC)/' mk/common.mk
    substituteInPlace Makefile --replace '-isystem $(DEPS_DIR)$(includedir)' '-isystem $(out)$(includedir)'
    substituteInPlace Makefile --replace '-L$(DEPS_DIR)$(libdir)' '-L$(out)$(libdir)'

    mkdir deps
    mkdir deps/src
    mkdir deps/src/nvidia-modprobe-396.51
    tar -C deps/src/nvidia-modprobe-396.51 --strip-components=1 -xz -f ${srcStatic} nvidia-modprobe-396.51/modprobe-utils
    touch deps/src/nvidia-modprobe-396.51/.download_stamp
  '';
}

