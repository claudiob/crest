#!/bin/sh
# Writes the houseaccount.vcf this page hands out, using the gem the page is about.
# Needs rsvg-convert and the crest gem; run it after editing cube.svg or the card's details.
set -e
cd "$(dirname "$0")"

rsvg-convert -w 512 -h 512 cube.svg -o .cube.png
trap 'rm -f .cube.png' EXIT

ruby -e "
  require 'pathname'
  require 'crest/card'
  print Crest::Card.new(name: 'HouseAccount', org: 'HouseAccount, Inc.',
                        phone: '+18005550100', email: 'support@houseaccount.com',
                        url: 'https://houseaccount.com/',
                        photo: Pathname.new('.cube.png')).to_s
" > houseaccount.vcf

echo 'houseaccount.vcf written by crest'
