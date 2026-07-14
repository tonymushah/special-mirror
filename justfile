set minimum-version := "1.56.0"

set lazy

gnu_llvm_path := env('GNU_LLVM_PATH')

[group("utils")]
cloc-project:
    cloc --vcs git

[group("project-setup")]
setup:
    vp i
    cargo fetch

[group("dev")]
dev:
    pnpm tauri dev

[group("dev")]
[group("next")]
dev-next:
    RUSTFLAGS='--cfg reqwest_unstable' pnpm tauri dev --features next

# Generates grahql sources for the UI
[group("gql_codegen")]
[group("mangadex")]
gql-mangadex-codegen:
    pnpm codegen -c ./src/lib/mangadex/codegen.ts && vp fmt --write src/lib/mangadex/gql

[group("dev")]
vite-dev:
    pnpm vite:dev

[group("dev")]
[group("hotpath")]
dev-hotpath:
    pnpm tauri dev -f hotpath

[group("alloc")]
[group("dev")]
[group("hotpath")]
dev-hotpath-alloc:
    pnpm tauri dev -f hotpath-alloc

[group("dev")]
[group("jemalloc")]
dev-jemalloc:
    pnpm tauri dev -f jemalloc

[group("build")]
build:
    pnpm tauri build

test-js:
    pnpm run test:integration && npm run test:unit

check-js:
    pnpm run check

cargo-clean:
    cargo clean 

cargo-clippy:
    cargo clippy

[group("build")]
[group("vite")]
vite-build:
    pnpm vite:build

[group("build")]
[group("build-no-bundle")]
build-no-bundle: vite-build
    cargo build -r --no-default-features -F no_bundle

[group("build")]
[group("build-no-bundle")]
[group("next")]
build-no-bundle-next: vite-build
    RUSTFLAGS='--cfg reqwest_unstable' cargo build -r --no-default-features -F no_bundle,next

[group("build")]
[group("build-no-bundle")]
[group("slow-build")]
slow-build-no-bundle: vite-build
    cargo build --profile release-slow-compile --no-default-features -F no_bundle

[group("build")]
[group("build-no-bundle")]
[group("next")]
[group("slow-build")]
slow-build-no-bundle-next: vite-build
    RUSTFLAGS='--cfg reqwest_unstable' cargo build --profile release-slow-compile --no-default-features -F no_bundle,next,mimalloc

# Slowly build the app for x86_64 linux
[group("build")]
[group("slow-build")]
[linux]
slow-build-linux-x86:
    pnpm tauri build -f mimalloc --target x86_64-unknown-linux-gnu -- --profile release-slow-compile

# Slowly build the app for aarch64 linux
[group("build")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64:
    pnpm tauri build -f mimalloc -r cargo-zigbuild --target aarch64-unknown-linux-gnu -- --profile release-slow-compile

# Slowly build the app for x86 windows on Linux by using `gnu-llvm`
#
# Require `llvm-gnu` and `nsis` to be installed.
# Require the `GNU_LLVM_PATH` to be set
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-x86-windows-gnu-llvm:
    PATH="{{ gnu_llvm_path }}/bin:$(echo $PATH)" pnpm tauri build -f mimalloc -b nsis --target x86_64-pc-windows-gnullvm -- --profile release-slow-compile

# Slowly build the app for x86 windows on Linux by using `cargo-xwin`
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-x86-windows-xwin:
    pnpm tauri build -f mimalloc -b nsis -r cargo-xwin --target x86_64-pc-windows-msvc -- --profile release-slow-compile

# Slowly build the app for aarch64 windows on Linux by using `gnu-llvm`
#
# Require `llvm-gnu` and `nsis` to be installed.
# Require the `GNU_LLVM_PATH` to be set
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64-windows-gnu-llvm:
    PATH="{{ gnu_llvm_path }}/bin:$(echo $PATH)" pnpm tauri build -f mimalloc -b nsis --target aarch64-pc-windows-gnullvm -- --profile release-slow-compile

# Slowly build the app for aarch64 windows on Linux by using `cargo-xwin`
[group("build")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64-windows-xwin:
    pnpm tauri build -f mimalloc -b nsis -r cargo-xwin --target aarch64-pc-windows-msvc -- --profile release-slow-compile

# Donwload llvm-mingw and set the `GNU_LLVM_PATH`
[env("LLVM_MINGW_BASE_DIR", "llvm-mingw-20260616-ucrt-ubuntu-22.04-x86_64")]
[env("LLVM_MINGW_DONWLOAD_PATH", "/tmp")]
[env("LLVM_MINGW_DOWNLOAD_URL", "https://github.com/mstorsjo/llvm-mingw/releases/download/20260616/llvm-mingw-20260616-ucrt-ubuntu-22.04-x86_64.tar.xz")]
[linux]
download-set-gnu_llvm_path:
    wget -O "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw.tar.xz" "$(echo $LLVM_MINGW_DOWNLOAD_URL)"	
    @echo "Downloaded"
    tar -xf "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw.tar.xz" -C "$(echo $LLVM_MINGW_DONWLOAD_PATH)/$(echo $LLVM_MINGW_BASE_DIR)"
    echo "$(echo $LLVM_MINGW_DONWLOAD_PATH)/$(echo $LLVM_MINGW_BASE_DIR)" >> "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm_gnu_path_file"
    @echo "Exported llvm-gnu to $(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm_gnu_path_file."
    @echo "Run 'cat \"$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm_gnu_path_file\"' to show the path."

[group("build")]
[group("slow-build")]
[linux]
slow-build-all: slow-build-linux-aarch64 slow-build-linux-aarch64-windows-gnu-llvm slow-build-linux-x86 slow-build-linux-x86-windows-gnu-llvm
    @echo "Built all"
