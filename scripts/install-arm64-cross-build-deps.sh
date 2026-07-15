#!/usr/bin/env bash

dpkg --add-architecture arm64

apt-get update

apt-get install -y \
  build-essential \
  procps \
  curl \
  wget \
  file:arm64 \
  libssl-dev:arm64 \
  libgtk-3-dev:arm64 \
  libappindicator3-dev:arm64 \
  xdg-utils:arm64 \
  librsvg2-dev:arm64 \
  apt-utils

apt-get install -y \
  libwebkit2gtk-4.1-0:arm64=2.44.0-2 \
  libwebkit2gtk-4.1-dev:arm64=2.44.0-2 \
  libjavascriptcoregtk-4.1-0:arm64=2.44.0-2 \
  libjavascriptcoregtk-4.1-dev:arm64=2.44.0-2 \
  gir1.2-javascriptcoregtk-4.1:arm64=2.44.0-2 \
  gir1.2-webkit2-4.1:arm64=2.44.0-2
