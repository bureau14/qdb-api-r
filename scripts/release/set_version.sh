#!/bin/sh
set -eu -o pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]] ; then
    >&2 echo "Usage: $0 <new_version>"
    exit 1
fi

INPUT_VERSION=$1; shift

MAJOR_VERSION=${INPUT_VERSION%%.*}
WITHOUT_MAJOR_VERSION=${INPUT_VERSION#${MAJOR_VERSION}.}
MINOR_VERSION=${WITHOUT_MAJOR_VERSION%%.*}
WITHOUT_MINOR_VERSION=${INPUT_VERSION#${MAJOR_VERSION}.${MINOR_VERSION}.}
PATCH_VERSION=${WITHOUT_MINOR_VERSION%%.*}

XYZ_VERSION="${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}"

if [[ "${INPUT_VERSION}" == *-* ]] ; then
    TAGS_VERSION=${INPUT_VERSION#*-}
    TAGS_VERSION=${TAGS_VERSION/nightly/}
    TAGS_VERSION=${TAGS_VERSION/./}
    TAGS_VERSION=$((9000 + ${TAGS_VERSION}))
    FULL_XYZB_VERSION="${XYZ_VERSION}.${TAGS_VERSION}"
else
    FULL_XYZB_VERSION="${INPUT_VERSION%%-*}"
fi

CURRENT_DATE=`date +%Y-%m-%d`

cd $(dirname -- $0)
cd ${PWD}/../..

# Version: 2.7.0.9000
# Date: 2018-05-16
sed -i \
    -e '/Version:/ { s/Version:.*/Version: '"${FULL_XYZB_VERSION}"'/ }' \
    -e '/Date:/ { s/Date:.*/Date: '"${CURRENT_DATE}"'/ }' \
    DESCRIPTION