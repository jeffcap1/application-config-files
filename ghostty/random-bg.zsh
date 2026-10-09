#!/bin/zsh
# Pick a random background image from art/ and write it to bg.conf,
# which the main ghostty config includes via `config-file = ?bg.conf`.

dir=~/.config/ghostty/art
out=~/.config/ghostty/bg.conf
imgs=($dir/*.(jpg|jpeg|png)(N))
(( ${#imgs} )) || exit 0

# avoid repeating the current image
cur=$(sed -n 's/^background-image = //p' $out 2>/dev/null)
(( ${#imgs} > 1 )) && imgs=(${imgs:#$cur})

print "background-image = ${imgs[RANDOM % ${#imgs} + 1]}" > $out
