{ stdenv, nodejs, pnpm, fetchFromGitHub, ... }:
stdenv.mkDerivation (finalAttrs: rec {
  name = "TidaLuna";
  pname = "${name}";
  version = "1.6.13-beta";
  src = fetchFromGitHub {
    hash = "sha256-xtVM8h1V3LyYmTBnKRzJEReq2jJVFHunRnzQIne7YAo=";
    owner = "Inrixia";
    repo = "${name}";
    rev = "${version}";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src version;
  };

  buildPhase = ''
    runHook preBuild

    pnpm install
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R "dist" "$out"

    runHook postInstall
  '';

})
