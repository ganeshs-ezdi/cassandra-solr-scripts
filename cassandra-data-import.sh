#! /bin/bash

# if there is already data into the system stop and give a warning

TAR_PATH=$1

if [[ "$TAR_PATH" == "" ]]; then
    echo "tar need to extract the script and execute"
    exit 0
fi

REALPATH=`which realpath`
if [[ "$REALPATH" == "" ]]; then
    echo "realpath does not exists please install 'realpath'"
    exit 0
fi

TAR_ABS_PATH=`realpath $TAR_PATH 2>/dev/null`

if [ ! -f "$TAR_ABS_PATH" ]; then
    echo "tar file does not exists"
    exit 0
fi

TMP_DIR=`mktemp -d`
pushd $TMP_DIR
echo Extracting $TAR_ABS_PATH to $TMP_DIR
tar -xf $TAR_ABS_PATH

KEYSPACES_DIRS=`find $TMP_DIR -mindepth 1 -maxdepth 1 -type d`

for KEYSPACE_DIR in $KEYSPACES_DIRS; do
    KEYSPACE=`basename $KEYSPACE_DIR`
    echo Found keyspace $KEYSPACE
done

popd
rm -r $TMP_DIR
