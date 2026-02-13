#! /bin/bash

: "${OCAML_VERSION:=5.4.0}"
: "${DUNE_VERSION:=3.21.0}"
: "${COQ_VERSION:=9.0.1}"

echo "" | bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"

opam init --bare --disable-sandboxing -y
opam switch create . ocaml-base-compiler.${OCAML_VERSION}
eval $(opam env)

opam install -y dune.${DUNE_VERSION} coq.${COQ_VERSION} logs fmt conf-zmq

mkdir -p ${AM_REPOS_ROOT}/cvm_deps

pushd ${AM_REPOS_ROOT}/
pushd cvm_deps

# Install RocqCandy - Copland Virtual Machine (CVM) dependency
git clone https://github.com/ku-sldg/rocq-candy.git \
    && pushd rocq-candy/ \
    && dune build \
    && dune install \
    && popd

# Install RocqJSON - Copland Spec dependency
git clone https://github.com/ku-sldg/rocq-json.git \
    && pushd rocq-json/ \
    && dune build \
    && dune install \
    && popd

# Install Copland Spec - Copland Virtual Machine (CVM) dependency
git clone https://github.com/ku-sldg/copland-spec.git \
    && pushd copland-spec/ \
    && dune build \
    && dune install \
    && popd

# Install Rocq CLI tools - CoplandManifestTools dependency
git clone https://github.com/ku-sldg/rocq-cli-tools.git \
    && pushd rocq-cli-tools/ \
    && dune build \
    && dune install \
    && popd

# Install EasyBakeCakeML - CoplandManifestTools dependency - FAILS
git clone https://github.com/Durbatuluk1701/EasyBakeCakeML.git \
    && pushd EasyBakeCakeML \
    && dune build \
    && dune install \
    && popd

# Install Bake - CoplandManifestTools dependency
git clone https://github.com/Durbatuluk1701/bake.git \
    && pushd bake/ \
    && dune build \
    && dune install \
    && popd

# Install CoplandManifestTools - Copland Virtual Machine (CVM) dependency
git clone https://github.com/ku-sldg/copland-manifest-tools.git \
    && pushd copland-manifest-tools \
    && dune build \
    && dune install \
    && popd

# Install RocqLogging - Copland Virtual Machine (CVM) dependency
git clone https://github.com/ku-sldg/rocq-logging.git \
    && pushd rocq-logging \
    && dune build \
    && dune install \
    && popd

popd # back to $AM_REPOS_ROOT

# Install Copland Virtual Machine (CVM) - Attestation Manager (AM) dependency
git clone https://github.com/ku-sldg/cvm.git \
    && pushd cvm \
    && dune build \
    && dune install \
    && popd

# Install asp-libs - Attestation Manager (AM) dependency
git clone https://github.com/ku-sldg/asp-libs \
    && pushd asp-libs \
    && make \
    && popd

export ASP_BIN=${AM_REPOS_ROOT}/asp-libs/target/release/

# Install Copland Evidence Tools - Attestation Manager (AM) dependency
git clone https://github.com/ku-sldg/copland-evidence-tools.git \
    && pushd copland-evidence-tools \
    && dune build && dune install \
    && popd

# Install Attestation Manager (AM)
git clone https://github.com/ku-sldg/rust-am-clients.git \
    && pushd rust-am-clients \
    && make \
    && popd

opam clean -a \
    && opam uninstall -y dune conf-zmq

rm -rf cvm_deps

popd
