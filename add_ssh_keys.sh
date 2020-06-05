#!/bin/bash
for i in `ls ~/.ssh`; do
  if [ `file ~/.ssh/$i | grep "private key" | wc -l` == 1 ]; then
    ssh-add -K ~/.ssh/$i
  fi
done
