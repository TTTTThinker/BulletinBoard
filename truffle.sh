#!/bin/bash

ENTRYPOINT="bash"
ARGS=""

PWD=$(readlink -f .)
SRCDIR="${PWD}/src"
USER="$(id -u):$(id -g)"

if [ $# -gt 0 ]; then
	ENTRYPOINT="truffle"
	for((i=1; i<=$#; ++i))
	do
		ARG=`eval echo '$'"$i"`
		ARGS="${ARGS} ${ARG}"
	done
fi

docker run -it --name truffle-BulletinBoard --rm \
	--user ${USER} --entrypoint ${ENTRYPOINT} \
	-p 0.0.0.0:80:80 -p 0.0.0.0:443:443 -v ${SRCDIR}:/truffle \
	ajmay/truffle $ARGS
