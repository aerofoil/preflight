#!/bin/bash
# Post installation script

createGit() {
    mkdir -p "/home/$USER/.config/aerofoil/git"
}


checkRoot() {
	if [[ ! "$(id -u)" -eq 0 ]]; then
		echo "Must be run as root"
		exit 1
	fi
}

checkConnection() {
	wget -q --tries=10 --timeout=5 -O - http://ftp.debian.org/debian/README > /dev/null
	if [[ $? -eq 0 ]]; then
		echo "Connection successful"
	else
		"Could not connect to ftp.debian.org. There might be a problem with your internet connection"
	fi
}
## Imports

importPrompt() {
	if [[ -f ${LIBDIR}/prompt ]]; then
		source ${LIBDIR}/prompt
	else
		echo "Could not find prompt"
		exit 1
	fi
}

LIBDIR='/usr/lib/lib-preflight'


createGit

checkRoot

checkConnection

importPrompt

# Run through steps
STEPS_BASIC=('apt-update' 'apt-dist-upgrade' 'install-af-audio' 'install-alternation'  'install-af-java' 'install-af-desktop' 'install-af-utils' 'install-af-graphics' 'devel')
STEPS_DEVEL=('install-af-cad' 'install-af-cpp')
STEP=1
(( STEPS = ${#STEPS_BASIC[@]} + ${#STEPS_DEVEL[@]} + 2 )) # 2 is intro and fini

. "$LIBDIR/intro"

for curStep in "${STEPS_BASIC[@]}"; do
    ((STEP++))
    . "$LIBDIR/$curStep"
done

if [[ $DEVEL ]]; then
    for curStep in "${STEPS_DEVEL[@]}"; do
        ((STEP++))
        . "$LIBDIR/$curStep"
    done
fi

. "$LIBDIR/fini"

exit 0
