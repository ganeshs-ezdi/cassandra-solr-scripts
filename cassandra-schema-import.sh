#! /bin/bash

# if schema already exists for any of the keyspaces don't create any
# if the schema for the keyspace does not exists then create it

TAR_PATH=$1

if [[ "$TAR_PATH" == "" ]]; then
    echo "tar need to extract the script and execute"
    exit 0
fi

TAR_ABS_PATH=`realpath $TAR_PATH 2>/dev/null`
TMP_DIR=`mktemp -d`

if [ ! -f "$TAR_ABS_PATH" ]; then
    echo "tar file does not exists"
    exit 0
fi

pushd $TMP_DIR
echo Extracting $TAR_ABS_PATH to $TMP_DIR
tar -xf $TAR_ABS_PATH

CQL_SCRIPTS=`find $TMP_DIR -name '*.cql'`
KEYSPACES=`cqlsh -e 'desc keyspaces;'`

for CQL_SCRIPT in $CQL_SCRIPTS; do
    KEYSPACE=`basename -s.cql $CQL_SCRIPT`
    KEYSPACE_IN_CASSANDRA=`echo $KEYSPACES | grep $KEYSPACE`
    if [[ "$KEYSPACE_IN_CASSANDRA" == "" ]]; then
        echo Can update keyspace $KEYSPACE
    fi
done

rm -r $TMP_DIR


