# Cross-compilation

Since I can't use Github Actions for building this app for the time being,
I need to find some exotic solution to build this thing across all platform 
within my own machine.

Even though Tauri doesn't explicitly support cross-compilation, 
the project somewhat does. 

There is some caveats though:
1. On Windows
- We use [`llvm-mingw`] for building the app (which is not recommended but Tauri docs)
- We only support [`nsis`] setup option for the time being.

2. On Linux: `aarch64-unknow-linux-gnu` require [`cross`].

## Support

Cross-compilation is only supported on Linux (since I am Fedora Linux user) 
and we currently support these targets:

- `x86_64-unknown-linux-gnu`
- `aarch64-unknown-linux-gnu` via [`cross`]. (There are some issues with the cross for now haha...)
- `x86_64-pc-windows-gnullvm` via [`llvm-mingw`]
- `x86_64-pc-windows-msvc` via [`cargo-xwin`]
- `aarch64-pc-windows-gnullvm` via [`llvm-mingw`]
- `aarch64-pc-windows-msvc` via [`cargo-xwin`]

## Building

Before we begin, make sure that you have the build dependencies and the corresponding target installed.

1. `x86_64-unknown-linux-gnu`

```bash
just slow-build-linux-x86
```
or 
```bash
just slow-build-linux-x86-with-portable
```
if you want to have a "portable" .tar.xz

And the bundles should be available at
`target/x86_64-unknown-linux-gnu/release-slow-compile/bundle`.
_The `appimage` directory is empty_.

2. `aarch64-unknown-linux-gnu`

Make sure you have [`docker`] (or [`podman`]) and [`cross`] installed.

```bash
just slow-build-linux-aarch64
```
or
```bash 
just slow-build-linux-aarch64-with-portable
``` 
if you want to have a "portable" .tar.xz

And the bundles should be available at
`target/aarch64-unknown-linux-gnu/release-slow-compile/bundle`.
_The `appimage` directory is empty_.

> ![IMPORTANT]
> This target might not build properly due some dependencies management hell inside the [`cross`] inside.

3. `x86_64-pc-windows-gnullvm`

First, (if you have done it yet) download [`llvm-mingw`] with:
```bash
just download-gnu-llvm
```

Secondly, (if not installed yet), install [`nsis`].
_Please refer [Tauri documentation](https://tauri.app/distribute/windows-installer/#install-nsis) on how to install [`nsis`] on Linux._

Then, run:
```bash
just slow-build-linux-x86-windows-gnu-llvm
```
or 
```bash 
just slow-build-linux-x86-windows-gnu-llvm-with-portable
```
if you want to have a "portable" .zip

And the bundles should be available at
`target/x86_64-pc-windows-gnullvm/release-slow-compile/bundle`.

4. `x86_64-pc-windows-msvc`

First, (if you have done it yet) install [`cargo-xwin`] with:
```bash
just install-cargo-xwin
```

_Don't forget to install [`llvm`], or `llvm-tools` component to avoid possible issues._

Secondly, (if not installed yet), install [`nsis`].
_Please refer [Tauri documentation](https://tauri.app/distribute/windows-installer/#install-nsis) on how to install [`nsis`] on Linux._

Then, run:
```bash
just slow-build-linux-x86-windows-xwin
```
or 
```bash
just slow-build-linux-x86-windows-xwin-with-portable
```
if you want to a "portable" .zip

And the bundles should be available at
`target/x86_64-pc-windows-msvc/release-slow-compile/bundle`.

5. `aarch64-pc-windows-gnullvm`

First, (if you have done it yet) download [`llvm-mingw`] with:
```bash
just download-gnu-llvm
```

Secondly, (if not installed yet), install [`nsis`].
_Please refer [Tauri documentation](https://tauri.app/distribute/windows-installer/#install-nsis) on how to install [`nsis`] on Linux._

Then, run:
```bash
just slow-build-linux-aarch64-windows-gnu-llvm
```
or 
```bash
just slow-build-linux-aarch64-windows-gnu-llvm-with-portable
```
If you want to have a "portable" .zip

And the bundles should be available at
`target/aarch64-pc-windows-gnullvm/release-slow-compile/bundle`.

6. `aarch64-pc-windows-msvc`

First, (if you have done it yet) install [`cargo-xwin`] with:
```bash
just install-cargo-xwin
```

_Don't forget to install [`llvm`], or `llvm-tools` component to avoid possible issues._

Secondly, (if not installed yet), install [`nsis`].
_Please refer [Tauri documentation](https://tauri.app/distribute/windows-installer/#install-nsis) on how to install [`nsis`] on Linux._

Then, run:
```bash
just slow-build-linux-aarch64-windows-xwin
# or 
# just slow-build-linux-aarch64-windows-xwin-with-portable
# If you want to a "portable" .zip
```

And the bundles should be available at
`target/aarch64-pc-windows-msvc/release-slow-compile/bundle`.

## Other [`just`] building recipes

- `slow-build-all-x86_64` (and its sister  `slow-build-all-x86_64-with-portable`): builds for all supported x86_64 targets (Linux and Windows via [`llvm-mingw`]).
- `slow-build-all-aarch64` (and its sister `slow-build-all-aarch64-with-portable`): builds for all suported aarch64 targets (Linux via [`cross`] and Windows via [`llvm-mingw`])

## MacOS support

No MacOS support until I get a Mac ;).

[`cargo-xwin`]: https://github.com/rust-cross/cargo-xwin
[`llvm-mingw`]: https://github.com/mstorsjo/llvm-mingw/
[`cross`]: https://github.com/cross-rs/cross
[`nsis`]: https://nsis.sourceforge.io/Main_Page
[`just`]: https://just.systems
[`docker`]: https://www.docker.com
[`podman`]: https://podman.io
[`llvm`]: https://llvm.org