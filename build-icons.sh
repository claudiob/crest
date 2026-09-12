#!/bin/sh
# Renders every icon a browser, a phone or a social network asks for from icon.svg.
# Needs rsvg-convert and magick; run it after editing the SVG and commit what changes.
set -e
cd "$(dirname "$0")"

# The mark is drawn on nothing, which is what a tab and a manifest want. iOS composites a
# bookmark onto black and every avatar is cropped onto somebody else's page, so those two get the
# white ground these marks are drawn for -- added here, so one drawing still answers every size.
sed 's|<g |<rect width="512" height="512" fill="#ffffff"/><g |' icon.svg > .ground.svg
trap 'rm -f .ground.svg' EXIT

rsvg-convert -w 96  -h 96  icon.svg     -o favicon-96x96.png
rsvg-convert -w 192 -h 192 icon.svg     -o web-app-manifest-192x192.png
rsvg-convert -w 512 -h 512 icon.svg     -o web-app-manifest-512x512.png
rsvg-convert -w 180 -h 180 .ground.svg  -o apple-touch-icon.png
rsvg-convert -w 1024 -h 1024 .ground.svg -o avatar.png

# one .ico holding the three sizes a browser reaches for when the page links nothing
for size in 16 32 48; do rsvg-convert -w $size -h $size icon.svg -o ".ico-$size.png"; done
magick .ico-16.png .ico-32.png .ico-48.png favicon.ico
rm -f .ico-16.png .ico-32.png .ico-48.png

echo 'icons rendered from icon.svg'
