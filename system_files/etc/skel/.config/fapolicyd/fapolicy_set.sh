#!/bin/bash

# whitlist binaries in .local/bin directory
sudo find ~/.local/bin -type f -exec fapolicyd-cli --file add {} \;

# whitlist ltex-ls
sudo find ~/.ltex-ls/ -type f -name "*.jar" -o -name "*.so" -exec fapolicyd-cli --file add {} \;
sudo find ~/.ltex-ls/ltex*/bin/ -type f -not -name ".*" -exec fapolicyd-cli --file add {} \;
sudo find ~/.ltex-ls/ltex*/jdk*/bin/ -type f -not -name ".*" -exec fapolicyd-cli --file add {} \;

# uptdate fapolicyd
sudo fapolicyd-cli --update
