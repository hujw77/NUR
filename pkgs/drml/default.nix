{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "drml";
  version = "debug-bsc";

  src = fetchFromGitHub {
    owner = "darwinia-network";
    repo = "darwinia-common";
    rev = "debug-bsc";
    sha256 = "sha256-ONTxgVz1l/kJsp1hW+xw8CbvXbIznejWvmoIHiqZX8Q=";
  };

  # cargoPatches = [ ./cargo-lock.patch ];

  cargoLock = {
     lockFile = ./Cargo.lock;
     outputHashes = {
        "bp-header-chain-0.1.0" = "0px3i8wc1l4l5bzzg863i9hkjcjdn647ma8q46lbs7fsd81zwqwf";
        "ckb-merkle-mountain-range-0.3.1" = "03bd1g4zvm24fwacfqy5b6wq66f8ls4xias9lslbn231b8hw9f4m";
        "ethash-0.4.2" = "0scx4bn3vmsgmkhvkzf65wwypzhxjkgsw5lysh4dhvghny0l9hps";
        "evm-0.30.1" = "10wis8r1782flc440lqwqdbbbnwj6zcgf3hlbh7q8irfay2c25qx";
        "fc-rpc-core-1.1.0-dev" = "140plq8i16nj03f7bmdyndx59rfnhiprf2bwwqsaxvc2j1hg7g3p";
        "fork-tree-3.0.0" = "1cf99f049ndybjsz8cwi2ka8myq7qd3rzzckpgwprbr221hlabz9";
        "substrate-fixed-0.5.7" = "155jxdrjp516d1jfrn13l1glw9cnwrp63flyah2h9fi7m5ic4qg7";
        "typenum-1.14.0" = "16sfx79zwff0qflj8q23g56lgv2rz9afixr5lwgqi9xr0sbb5kr6";
     };
   };

  nativeBuildInputs = [ clang ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  cargoBuildFlags = [ "--profile" "release-lto" "--bin" "drml" ];

  meta = with lib; {
    description = "Darwinia Runtime Pallet Library and Pangolin/Pangoro Testnet";
    homepage = "https://darwinia.network";
    license = licenses.gpl3Only;
    maintainers = [ "hujw77" ];
    platforms = platforms.linux;
  };
}
