{ runc, fetchpatch }:

runc.overrideAttrs(oldAttrs: rec {
  name = "runc-nvidia";

  patches = [
    (fetchpatch {
      name = "0001-Add-prestart-hook-nvidia-container-runtime-hook-to-t.patch";
      url = "https://raw.githubusercontent.com/NVIDIA/nvidia-container-runtime/662d8b1648d3cde2be880ccfe4cdb14929fd5684/runtime/runc/3f2f8b84a77f73d38244dd690525642a72156c64/0001-Add-prestart-hook-nvidia-container-runtime-hook-to-t.patch";
      sha256 = "0hgzxzcv9a2nw1iqw0sis5r8midf6nz7468xf1rwyfs97d32195q";
    })
  ];

  installPhase = ''
    install -Dm755 runc $out/bin/nvidia-container-runtime

    # Include contributed man pages
    man/md2man-all.sh -q
    manRoot="$man/share/man"
    mkdir -p "$manRoot"
    for manDir in man/man?; do
      manBase="$(basename "$manDir")" # "man1"
      for manFile in "$manDir"/*; do
        manName="$(basename "$manFile")" # "docker-build.1"
        mkdir -p "$manRoot/$manBase"
        gzip -c "$manFile" > "$manRoot/$manBase/$manName.gz"
      done
    done
  '';
})
