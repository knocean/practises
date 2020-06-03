with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "python";
  buildInputs = [
    python38Full
  ];
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
  '';
}
