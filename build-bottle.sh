#!/bin/bash

brew uninstall mimium

brew install mimium --build-bottle

brew bottle mimium --root-url=https://github.com/mimium-org/homebrew-mimium/releases/download/v0.1.1 --verbose 