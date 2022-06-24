#!/bin/bash

rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -DCMAKE_PREFIX_PATH=/opt/qt515 ..
make -j $(nproc)
cd ..
