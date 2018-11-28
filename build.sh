#!/bin/bash

PREFIX=/opt

source /opt/intel/mkl/bin/mklvars.sh intel64

echo "Installing cmake"
CMAKE=cmake-3.13.1-Linux-x86_64.tar.gz
wget https://github.com/Kitware/CMake/releases/download/v3.13.1/$CMAKE
tar -xf $CMAKE
cd ${CMAKE%.tar.gz}
export PATH=$PATH:$(pwd)/bin
cd -

echo "Setting up SuiteSparse..."
tar -xf $SUITESPARSE
sed -i 's/-lmkl_intel_thread/-lmkl_sequential/g' SuiteSparse/SuiteSparse_config/SuiteSparse_config.mk
cd SuiteSparse
make library
make install INSTALL=$PREFIX/SuiteSparse
cd -

echo "Setting up HYPRE..."
tar -xf $HYPRE
cd ${HYPRE%.tar.gz}/src
./configure --prefix=$PREFIX/hypre CC=mpicc CXX=mpicxx
make -j 4
make install
cd -

echo "Setting up TTL..."
cd ttl
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX/ttl -DBLA_VENDOR=Intel10_64lp_seq .
make -j 4
make install
cd -

echo "Setting up GCM..."
cd gcm
./bootstrap
./configure --with-ttl=$PREFIX/ttl CXXFLAGS="-O3"
make -j 4
cd -

echo "Setting up PGFEM3D..."
cd pgfem-3d
./bootstrap
./configure --prefix=$PREFIX/pgfem-3d \
	    --with-suitesparse=$PREFIX/SuiteSparse \
	    --with-hypre=$PREFIX/hypre \
	    --with-ttl=$PREFIX/ttl \
	    --with-cnstvm=$HOME/gcm \
	    --disable-vtk \
	    --enable-tests \
	    --with-tests-nprocs=4 \
	    CC=mpicc CXX=mpicxx CXXFLAGS="-O3"
make -j 4
make install
cd -
