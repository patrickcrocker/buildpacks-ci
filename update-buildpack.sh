#!/bin/bash
#
# All CF_* variables are provided externally from this script

set -e -x

if [ "true" = "$CF_SKIP_SSL" ]; then
  cf api $CF_API_URL --skip-ssl-validation
else
  cf api $CF_API_URL
fi

# Login to CF

cf auth $CF_USERNAME $CF_PASSWORD

cf target -o system -s system

filename=$(basename buildpacks/*.zip)
filename_base=${filename%-v[0-9]*}

buildpack_name=$(cf buildpacks | grep $filename_base | cut -d " " -f 1)

cf update-buildpack $buildpack --unlock

cf update-buildpack $buildpack -p buildpacks/$filename

cf update-buildpack $buildpack --lock
