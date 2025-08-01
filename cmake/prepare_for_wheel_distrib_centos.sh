#!/bin/sh

# This file should not go here, but I've not found a better place yet.
# Intended for CentOS 7 / manylinux2014

# Install git
yum install -y git

# Clone the libdwarf code repository
git clone https://github.com/davea42/libdwarf-code.git

# Install the required packages for building libdwarf
yum install -y https://archives.fedoraproject.org/pub/archive/epel/6/i386/Packages/l/libzstd-devel-1.4.5-3.el6.i686.rpm https://archives.fedoraproject.org/pub/archive/epel/6/i386/Packages/l/libzstd-1.4.5-3.el6.i686.rpm
yum install -y gcc gcc-c++ make autoconf automake libtool pkgconfig zlib-devel

# Change to the libdwarf directory
cd libdwarf-code

# Checkout the specific commit for consistency
git checkout 442cd4f9b094a92ac7b8f493507cd0d4f3e7947a

# Run the autogen script to generate the configure script
env -i sh autogen.sh

# Configure the build system
CFLAGS="-O2" ./configure --enable-shared --disable-dependency-tracking

# Build the library
make -j$(nproc)

# Install the library
make install

# Go back to the home directory
cd ..

# Clone the libelf repository
git clone git://sourceware.org/git/elfutils.git  --branch elfutils-0.193 --depth 1

# Install the required packages for building libelf
yum install -y bzip2-devel xz-devel libarchive gettext-devel flex bison libcurl-devel json-c-devel

# Change to the libelf directory
cd elfutils

# Configure the build system
env -i autoreconf -fvi
CFLAGS="-O2" ./configure --enable-libdebuginfod --enable-maintainer-mode

# Build the library
make -j$(nproc)

# Install the library
make install

# Install libiberty
yum install -y binutils-devel
