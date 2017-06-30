#!/usr/bin/env bash

make ;
. ~/.profile
cd installs/
make video
cd ../
make install
cd installs/
make dev/envup
cd ../