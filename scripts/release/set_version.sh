#!/bin/sh
set -eu -o pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]] ; then
    >&2 echo "Usage: $0 <new_version>"
    exit 1
fi

INPUT_VERSION=$1; shift

IFS='.-' read -ra VERSION_PARTS <<< "${INPUT_VERSION}"
XYZ_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.${VERSION_PARTS[2]}"
    
IFS='-' read -ra DASH_PARTS <<< "${INPUT_VERSION}"
AFTER_DASH="${DASH_PARTS[1]}"
IFS='.' read -ra TAG_PARTS <<< "${AFTER_DASH}"

if [[ "${TAG_PARTS[0]}" == "nightly" ]] ; then
    TAGS_VERSION=$((9000 + ${TAG_PARTS[1]}))
    FULL_XYZB_VERSION="${XYZ_VERSION}.${TAGS_VERSION}"
else
    FULL_XYZB_VERSION="${INPUT_VERSION%%-*}"
fi

CURRENT_DATE=`date +%Y-%m-%d`

>&2 echo "FULL_XYZB_VERSION: $FULL_XYZB_VERSION"
>&2 echo "CURRENT_DATE: $CURRENT_DATE"

cd $(dirname -- $0)
cd ${PWD}/../..

# Version: 2.7.0.9000
# Date: 2018-05-16
sed -i \
    -e '/Version:/ { s/Version:.*/Version: '"${FULL_XYZB_VERSION}"'/ }' \
    -e '/Date:/ { s/Date:.*/Date: '"${CURRENT_DATE}"'/ }' \
    DESCRIPTION