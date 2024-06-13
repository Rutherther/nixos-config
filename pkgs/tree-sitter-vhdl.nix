{ tree-sitter, fetchFromGitHub }:

tree-sitter.buildGrammar {
  language = "tree-sitter-vhdl";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "alemuller";
    repo = "tree-sitter-vhdl";
    rev = "a3b2d84990527c7f8f4ae219c332c00c33d2d8e5";
    hash = "sha256-CtlhSAKp90nXLI5g+vAd0dZZxjPTyMcNFvHL8DBY4j8=";
  };
}
