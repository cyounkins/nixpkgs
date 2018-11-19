{stdenv, fetchFromGitHub, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper, ncurses
, enableX11 ? true}:

stdenv.mkDerivation (rec {
  name = "unison";
  version = "2.51.2";
  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${version}";
    sha256 = "1bykiyc0dc5pkw8x370qkg2kygq9pq7yqzsgczd3y13b6ivm4sdq";
  };

  buildInputs = [ ocaml makeWrapper ncurses ];

  preBuild = ''
    cd src
    # Don't build etags for right now
    sed -i "s/all:: TAGS//" Makefile
  '' + (if enableX11 then ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)|" Makefile.OCaml
  '' else "") + ''
    echo -e '\ninstall:\n\tcp $(FSMONITOR)$(EXEC_EXT) $(INSTALLDIR)' >> fsmonitor/linux/Makefile
  '';

  makeFlags = "INSTALLDIR=$(out)/bin/" + (if enableX11 then " UISTYLE=gtk2" else "")
    + (if ! ocaml.nativeCompilers then " NATIVE=false" else "");

  preInstall = ''
    mkdir -p $out/bin
    # Don't run this mv to save a previous install
    sed -Ei "s/\w*-mv \\$\(INSTALLDIR\)\/\\$\(NAME\)\\$\(EXEC_EXT\) \/tmp\/\\$\(NAME\)-\\$\(shell echo \\$\\$\\$\\$\)\$//" Makefile
  '';

  postInstall = if enableX11 then ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done
  '' else "";

  dontStrip = !ocaml.nativeCompilers;

  meta = {
    homepage = http://www.cis.upenn.edu/~bcpierce/unison/;
    description = "Bidirectional file synchronizer";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; unix;
  };

})
