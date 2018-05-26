#!/usr/bin/env bash

petlove-ssh() {
  cd ~/projects/petlove/fort-knox/ 2>&1 1> /dev/null
  git pull 2>&1
  ./ssh-config-builder/create_ssh_config.rb 2>&1;
  cd - 2>&1 1> /dev/null;
}
