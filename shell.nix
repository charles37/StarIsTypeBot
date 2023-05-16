let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [ 
    pkgs.stack 
    pkgs.zlib
  ];

  NIX_PATH = "nixpkgs=" + pkgs.path;

}




