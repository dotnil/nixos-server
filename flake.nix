{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.agenix.inputs.darwin.follows = "";

    todo-vue.url = "github:dotnil/todo-vue";
    todo-vue.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    disko,
    agenix,
    ...
  }@inputs: {
    # firstvds
    # nix run github:nix-community/nixos-anywhere -- --flake .#frakurai root@frakurai
    # nixos-rebuild switch --flake .#frakurai --target-host root@frakurai --fast
    nixosConfigurations.frakurai = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./disko-vda.nix
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/frakurai.nix
      ];
      specialArgs.inputs = inputs;
    };
    nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./hosts/installer.nix
      ];
    };
  };
}
