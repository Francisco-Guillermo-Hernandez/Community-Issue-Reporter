#!/bin/sh

#  ci_post_clone.sh
#  Community Issue Reporter
#
#  Derives the build number from Xcode Cloud's CI_BUILD_NUMBER so that every
#  upload gets a unique CFBundleVersion. App Store Connect rejects a build
#  whose version was already uploaded, and a hardcoded number fails on the
#  second upload of the same marketing version.
#
#  The app target sets GENERATE_INFOPLIST_FILE = YES, so CFBundleVersion comes
#  from the CURRENT_PROJECT_VERSION build setting instead of the Info.plist.
#  That is why this rewrites the pbxproj rather than patching a plist.

set -e

if [ -z "$CI_BUILD_NUMBER" ]; then
    echo "CI_BUILD_NUMBER is not set, leaving the build number untouched."
    exit 0
fi

PROJECT_FILE="$CI_PRIMARY_REPOSITORY_PATH/Community Issue Reporter.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "error: project file not found at $PROJECT_FILE"
    exit 1
fi

sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = $CI_BUILD_NUMBER;/g" "$PROJECT_FILE"

echo "Build number set to $CI_BUILD_NUMBER."
