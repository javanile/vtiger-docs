#!/usr/bin/env bash

versions=(
  7.2.0
  7.1.0
)

for version in "${versions[@]}"; do
  [[ ! -d vtiger-core ]] && git clone https://github.com/javanile/vtiger-core/
  cd vtiger-core
  git checkout tags/${version} -b current
  cat vtigerversion.php | grep -e "^\$vtiger_current_version"
  cd ..

  while IFS= read line || [[ -n "${line}" ]]; do
    make parse take="${version} ${line}"
  done < toc.file

  cd vtiger-core
  git checkout master
  git branch -D current
  cd ..
done
