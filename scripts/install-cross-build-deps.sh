#!/usr/bin/env bash

sudo apt update

sudo apt install -y \
  build-essential \
  procps \
  curl \
  wget \
  file \
  libssl-dev \
  libgtk-3-dev \
  libappindicator3-dev \
  xdg-utils \
  librsvg2-dev

sudo apt install -y \
  libwebkit2gtk-4.1-0=2.44.0-2 \
  libwebkit2gtk-4.1-dev=2.44.0-2 \
  libjavascriptcoregtk-4.1-0=2.44.0-2 \
  libjavascriptcoregtk-4.1-dev=2.44.0-2 \
  gir1.2-javascriptcoregtk-4.1=2.44.0-2 \
  gir1.2-webkit2-4.1=2.44.0-2