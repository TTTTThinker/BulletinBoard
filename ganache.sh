#!/bin/bash

docker run -it --rm --name ganache \
	-p 0.0.0.0:7545:7545 -p 0.0.0.0:8545:8545 \
	trufflesuite/ganache-cli
