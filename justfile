set minimum-version := "1.56.0"

set lazy

gnu_llvm_path := env('GNU_LLVM_PATH', '.gnu-llvm/llvm-mingw')
app_version := env("APP_VERSION", '0.2.4')

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

[group("build")]
[group("slow-build")]
slow-build:
    pnpm tauri build -- --profile release-slow-compile

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
    RUSTFLAGS='--cfg reqwest_unstable' pnpm tauri build -f mimalloc,http3 --target x86_64-unknown-linux-gnu -b rpm,deb -- --profile release-slow-compile

# Slowly build the app for x86_64 linux with portable release
[group("build")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/x86_64-unknown-linux-gnu/release-slow-compile')]
slow-build-linux-x86-with-portable: slow-build-linux-x86
    mkdir -p bundle/portable
    tar -cJf "bundle/portable/Special Eureka-{{ app_version }}-x86_64-linux-portable.tar.xz" special-eureka 

# Slowly build the app for aarch64 linux
[group("build")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64:
    pnpm tauri build -f mimalloc -r cross --target aarch64-unknown-linux-gnu -b rpm,deb -- --profile release-slow-compile -v

# Slowly build the app for aarch64 linux with portable release
[group("build")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/aarch64-unknown-linux-gnu/release-slow-compile')]
slow-build-linux-aarch64-with-portable: slow-build-linux-aarch64
    mkdir -p bundle/portable
    tar -cJf "bundle/portable/Special Eureka-{{ app_version }}-aarch64-linux-portable.tar.xz" special-eureka 

# Slowly build the app for x86 windows on Linux by using `gnu-llvm`
#
# Require `llvm-gnu` and `nsis` to be installed.
# Require the `GNU_LLVM_PATH` to be set
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-x86-windows-gnu-llvm:
    RUSTFLAGS='--cfg reqwest_unstable' PATH="$(pwd)/{{ gnu_llvm_path }}/bin:$(echo $PATH)" pnpm tauri build -f mimalloc,http3 -b nsis --target x86_64-pc-windows-gnullvm -- --profile release-slow-compile

# Slowly build the app for x86 windows on Linux by using `gnu-llvm` with portable bundle
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/x86_64-pc-windows-gnullvm/release-slow-compile')]
slow-build-linux-x86-windows-gnu-llvm-with-portable: slow-build-linux-x86-windows-gnu-llvm
    mkdir -p bundle/portable
    zip -r "bundle/portable/Special Eureka-{{ app_version }}-x86_64-windows-portable.zip" special-eureka.exe WebView2Loader.dll

# Slowly build the app for x86 windows on Linux by using `cargo-xwin`
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-x86-windows-xwin:
    pnpm tauri build -f mimalloc -b nsis -r cargo-xwin --target x86_64-pc-windows-msvc -- --profile release-slow-compile

# Slowly build the app for x86 windows on Linux by using `cargo-xwin` with portable bundle
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/x86_64-pc-windows-msvc/release-slow-compile')]
slow-build-linux-x86-windows-xwin-with-portable: slow-build-linux-x86-windows-xwin
    mkdir -p bundle/portable
    zip -r "bundle/portable/Special Eureka-{{ app_version }}-x86_64-windows-portable.zip" special-eureka.exe WebView2Loader.dll

# Slowly build the app for aarch64 windows on Linux by using `gnu-llvm`
#
# Require `llvm-gnu` and `nsis` to be installed.
# Require the `GNU_LLVM_PATH` to be set
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64-windows-gnu-llvm:
    PATH="$(pwd)/{{ gnu_llvm_path }}/bin:$(echo $PATH)" pnpm tauri build -f mimalloc -b nsis --target aarch64-pc-windows-gnullvm -- --profile release-slow-compile

# Slowly build the app for aarch64 windows on Linux by using `gnu-llvm` with portable bundle
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/aarch64-pc-windows-gnullvm/release-slow-compile')]
slow-build-linux-aarch64-windows-gnu-llvm-with-portable: slow-build-linux-aarch64-windows-gnu-llvm
    mkdir -p bundle/portable
    zip -r "bundle/portable/Special Eureka-{{ app_version }}-aarch64-windows-portable.zip" special-eureka.exe WebView2Loader.dll

# Slowly build the app for aarch64 windows on Linux by using `cargo-xwin`
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-linux-aarch64-windows-xwin:
    pnpm tauri build -f mimalloc -b nsis -r cargo-xwin --target aarch64-pc-windows-msvc -- --profile release-slow-compile

# Slowly build the app for aarch64 windows on Linux by using `cargo-xwin`
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
[working-directory('target/aarch64-pc-windows-msvc/release-slow-compile')]
slow-build-linux-aarch64-windows-xwin-with-portable: slow-build-linux-aarch64-windows-xwin
    mkdir -p bundle/portable
    zip -r "bundle/portable/Special Eureka-{{ app_version }}-aarch64-windows-portable.zip" special-eureka.exe WebView2Loader.dll

# Donwload llvm-mingw to normally .gnu-llvm/llvm-mingw
[env("LLVM_MINGW_BASE_DIR", "llvm-mingw-20260616-ucrt-ubuntu-22.04-x86_64")]
[env("LLVM_MINGW_DONWLOAD_PATH", ".gnu-llvm")]
[env("LLVM_MINGW_DOWNLOAD_URL", "https://github.com/mstorsjo/llvm-mingw/releases/download/20260616/llvm-mingw-20260616-ucrt-ubuntu-22.04-x86_64.tar.xz")]
[group("build")]
[group("utils")]
[linux]
download-gnu-llvm:
    wget -O "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw.tar.xz" "$(echo $LLVM_MINGW_DOWNLOAD_URL)"	
    @echo "Downloaded"
    rm -rf "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw"
    mkdir -p "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw"
    tar -xf "$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw.tar.xz" -C "$(echo $LLVM_MINGW_DONWLOAD_PATH)"
    mv $(echo $LLVM_MINGW_DONWLOAD_PATH)/$(echo $LLVM_MINGW_BASE_DIR)/* $(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw
    rmdir $(echo $LLVM_MINGW_DONWLOAD_PATH)/$(echo $LLVM_MINGW_BASE_DIR)
    @echo "Downloaded llvm-mingw to \"$(echo $LLVM_MINGW_DONWLOAD_PATH)/llvm-mingw\" to show the path."

# Build for all x86_64 target: using linux and windows gnu
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-all-x86_64: slow-build-linux-x86 slow-build-linux-x86-windows-gnu-llvm
    @echo "Built all x86_64 linux and windows (gnu) targets"

# Build for all x86_64 target with portable bundle: using linux and windows gnu
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
slow-build-all-x86_64-with-portable: slow-build-linux-x86-with-portable slow-build-linux-x86-windows-gnu-llvm-with-portable
    @echo "Built all x86_64 linux and windows (gnu) targets with their portable bundle"

# Build for all aarch64 target: using linux and windows gnu
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[linux]
slow-build-all-aarch64: slow-build-linux-aarch64 slow-build-linux-aarch64-windows-gnu-llvm
    @echo "Built all x linux and windows (gnu) targets"

# Build for all aarch64 target with portable bundle: using linux and windows gnu
[group("build")]
[group("linux-windows")]
[group("slow-build")]
[group("with-portable")]
[linux]
slow-build-all-aarch64-with-portable: slow-build-linux-aarch64-with-portable slow-build-linux-aarch64-windows-gnu-llvm-with-portable
    @echo "Built all x linux and windows (gnu) targets with their portable bundle"

[group("build")]
[group("utils")]
[linux]
install-cross:
    cargo install cross --git https://github.com/cross-rs/cross#64b5bb4d

[group("build")]
[group("utils")]
[linux]
install-cargo-xwin:
    cargo install cargo-xwin
