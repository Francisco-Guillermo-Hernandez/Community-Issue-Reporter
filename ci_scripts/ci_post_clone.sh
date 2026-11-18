#!/bin/sh

#  ci_post_clone.sh
#  Community Issue Reporter
#
#  Sets both version numbers before Xcode Cloud builds the app:
#
#  - CFBundleVersion comes from CI_BUILD_NUMBER, so every upload is unique.
#    App Store Connect rejects a build number it has already seen.
#
#  - CFBundleShortVersionString comes from the highest v* git tag, which names
#    the version currently being built. Tag the next version right after a
#    release ships: once a version is approved its pre-release train closes,
#    and further builds are rejected with "Invalid Pre-Release Train".
#
#  The app target sets GENERATE_INFOPLIST_FILE = YES, so both values come from
#  build settings instead of the Info.plist. That is why this rewrites the
#  pbxproj rather than patching a plist.

set -e

REPO="${CI_PRIMARY_REPOSITORY_PATH:-$(git rev-parse --show-toplevel)}"
PROJECT_FILE="$REPO/Community Issue Reporter.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "error: project file not found at $PROJECT_FILE"
    exit 1
fi

if [ -n "$CI_BUILD_NUMBER" ]; then
    sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = $CI_BUILD_NUMBER;/g" "$PROJECT_FILE"
    echo "Build number set to $CI_BUILD_NUMBER."
else
    echo "CI_BUILD_NUMBER is not set, leaving the build number untouched."
fi

# Xcode Cloud clones without tags, so fetch them before picking the highest.
git -C "$REPO" fetch --tags --force --quiet 2>/dev/null || true

# Tags that are not of the form vMAJOR.MINOR[.PATCH] are ignored rather than
# failing the build, since they sort above real versions.
TAG=$(git -C "$REPO" tag --list 'v*' --sort=-v:refname | grep -E '^v[0-9]+(\.[0-9]+){1,2}$' | head -n 1)

if [ -z "$TAG" ]; then
    echo "warning: no version tag found, leaving the marketing version untouched."
    echo "warning: tag the version being built, for example 'git tag v1.1.2'."
    exit 0
fi

VERSION=${TAG#v}

sed -i '' -E "s/MARKETING_VERSION = [0-9.]+;/MARKETING_VERSION = $VERSION;/g" "$PROJECT_FILE"
echo "Marketing version set to $VERSION from tag $TAG."
