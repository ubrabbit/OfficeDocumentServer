#!/bin/bash

function ErrorExit()
{
    if [ "$?" != "0" ]; then
        echo $1
        exit 1
    fi
}

CURREND_PWD=`pwd`

SOURCE_VERSION="3.6.8"
FILENAME="Python-${SOURCE_VERSION}.tgz"

INSTALL_DIR=${HOME}/python3/${SOURCE_VERSION}
SOURCE_DIR=${HOME}/python3/src

rm -rf ${SOURCE_DIR} 2>&1 > /dev/null
mkdir -p ${SOURCE_DIR} && cd ${SOURCE_DIR}

wget "https://www.python.org/ftp/python/${SOURCE_VERSION}/${FILENAME}"
ErrorExit "下载失败！"

tar xvf ${FILENAME} && cd Python-${SOURCE_VERSION}
ErrorExit "进入源码目录失败！"

sudo apt-get -y install python-dev
sudo apt-get -y install libffi-dev
sudo apt-get -y install libssl-dev
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev

rm -rf ${INSTALL_DIR} 2>&1 > /dev/null
mkdir -p `dirname ${INSTALL_DIR}`
./configure --prefix=${INSTALL_DIR} --with-ensurepip=yes --with-ssl-default-suites=python --with-lto
ErrorExit "执行 configure 失败！"

make clean && make -j "$(nproc)"
ErrorExit "执行 make 失败！"

make install
ErrorExit "执行 make install 失败！"

sudo unlink /usr/bin/python3
sudo ln -s ${HOME}/python3/${SOURCE_VERSION}/bin/python3 /usr/bin/python3
sudo apt-get -y install python3-pip
sudo python3 -m pip install --upgrade pip
