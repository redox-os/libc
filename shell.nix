with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "libc";

  nativeBuildInputs = [ autoconf264 automake111x flex bison  ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "all" ];
}
