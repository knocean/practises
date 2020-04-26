with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "python";
  buildInputs = [
    python38Packages.virtualenv
  ];
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    virtualenv _venv
    source _venv/bin/activate
    pip install -r requirements.txt
  '';
}
