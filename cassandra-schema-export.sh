#! /bin/bash

CQLSH=`which cqlsh`

if [[ "$CQLSH" == "" ]]; then
    echo "cqlsh does not exits"
    exit 1
fi

if [[ "$1" == "" ]]
    KEYSPACES=`cqlsh -e 'desc keyspaces' | sed -e 's/  */\n/g' | grep ez`
else
    KEYSPACES="$*"
fi

TMP_DIR=`mktemp -d`

for KEYSPACE in $KEYSPACES; do
    cqlsh -e "DESC KEYSPACE $KEYSPACE" > $TMP_DIR/$KEYSPACE.cql
done

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OLD_DIR=$PWD

pushd $TMP_DIR
tar -cvf $OLD_DIR/cassandra-schema-export-$TIMESTAMP.tar.gz *.cql
popd

rm -r $TMP_DIR

