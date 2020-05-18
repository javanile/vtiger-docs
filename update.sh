#!/usr/bin/env bash
set -e

  #7.2.0

versions=(
  7.1.0
)

for version in "${versions[@]}"; do
  [[ ! -d vtiger-core ]] && git clone https://github.com/javanile/vtiger-core/
  cd vtiger-core
  git checkout master
  git branch -D current && true
  git checkout tags/${version} -b current
  cat vtigerversion.php | grep -e "^\$vtiger_current_version"
  cp ../Doxyfile.template ./Doxyfile
  #sed -e 's!%VERSION%!'"${version}"'!g' -ri composer.json

  [[ -d html ]] && rm -fr html
  mkdir html
  doxygen
  rm -fr latex

  [[ -d ../docs/${version} ]] && rm -fr ../docs/${version}
  mv html ../docs/${version}
  rm Doxyfile
  cd ..

  while IFS= read line || [[ -n "${line}" ]]; do
    make parse take="${version} ${line}"
  done < toc.file

  cd vtiger-core
  git checkout master
  git branch -D current
  cd ..
done
