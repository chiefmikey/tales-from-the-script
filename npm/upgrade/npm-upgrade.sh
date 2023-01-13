#!/bin/sh

echo "+ npm global upgrade"
cd ${HOME}

export STATUS=0
for package in $(npm ls -g --json | jq '.dependencies | keys' | awk -F'"' '{print $2}'); do
  export v1=$(${package} --version)
  if [ "${package}" = "npm" ]; then
    package="npm@next-9"
  fi
  if [ $(npm view ${package} version) != ${v1} ]; then
     npm i -gs ${package}
     if [ "${package}" = "npm" ]; then
       package="npm"
     fi
     export v2=$(${package} --version)
     echo "${package} (${v1} -> ${v2})"
     export STATUS=1
  fi;
done

[ ${STATUS} -eq 0 ] && echo "Already up-to-date."