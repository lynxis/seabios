#!/bin/sh
# Script to generate a C file with version information.
OUTFILE="$1"
VAR16MODE="$2"
DATE=""
# Extract version info
if [ -d .git -o -f .git ]; then
    VERSION="`git describe --tags --long --dirty`"
    if git update-index -q --refresh >/dev/null; \
       git diff-index --quiet HEAD; then
      DATE=$(git log --date=local --pretty=format:%ct -1)
    else
      DATE=$(date +%s)
    fi
elif [ -f .version ]; then
    VERSION="`cat .version`"
else
    VERSION="?"
fi
VERSION="${VERSION}-`date -d @$DATE +"%Y%m%d_%H%M%S"`-buildhost"
echo "Version: ${VERSION}"

# Build header file
if [ "$VAR16MODE" = "VAR16" ]; then
    cat > ${OUTFILE} <<EOF
#include "types.h"
char VERSION[] VAR16 = "${VERSION}";
EOF
else
    cat > ${OUTFILE} <<EOF
char VERSION[] = "${VERSION}";
EOF
fi
