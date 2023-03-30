{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, pythonOlder


  # propagates
, pkg-config
, regex
, requests
, rustPlatform
, setuptools-rust

  # tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5YucJjoYAUTRy7oJ3yb2uE1UZDLIPXnV0bJIDgwGOeA=";
  };

  patches = [ ./add-cargo-lock.patch ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-NJi8Sisw/bDIuAvykG9olrX8Ki01ehlERCVS5nsj0gA=";
  };

  propagatedBuildInputs = [
    regex
    requests
  ];

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    rust.cargo
    rust.rustc
  ]);

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "a fast BPE tokeniser for use with OpenAI's models.";
    homepage = "https://github.com/openai/tiktoken";
    license = licenses.mit;
    maintainers = with maintainers; [ MayNiklas ];
  };
}
