{ lib, ... }:

{
  options.wg = {
    ip = lib.mkOption {
      type = lib.types.str;
    };
  };
}
