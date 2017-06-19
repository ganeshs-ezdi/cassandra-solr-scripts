#! /bin/bash

# if there is already data into the system stop and give a warning

function echo_right()
{
    MSG=$1
    RIGHT=$2
    LEN=`echo $MSG | wc -c`
    COLS=`tput cols`
    printf '%s%*s%s' "$MSG" `expr $COLS - $LEN + 1` "$RIGHT"
}

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
    TABLES_CSV=`find $TMP_DIR/$KEYSPACE -name '*.csv'`

    echo Checking if we can update $KEYSPACE

    CAN_UPDATE_KEYSPACE="YES"
    TABLE_WHICH_HAS_DATA=""

    for TABLE_CSV in $TABLES_CSV; do
        TABLE=`basename -s.csv $TABLE_CSV`

        echo Checking if $TABLE contains data
        TABLE_HAS_RECORDS=`cqlsh -e "select * from $KEYSPACE.$TABLE limit 1" | tail -n 1 | grep '(0 rows)'`
        # if it has records the TABLE_HAS_RECORDS is NULL STRING
        if [[ "$TABLE_HAS_RECORDS" == "" ]]; then
            CAN_UPDATE_KEYSPACE="NO"
            TABLE_WHICH_HAS_DATA=$TABLE
            break
        else
            echo $TABLE does not contains any data == $TABLE_HAS_RECORDS ==
        fi
    done

    if [[ "$CAN_UPDATE_KEYSPACE" == "YES" ]]; then
        echo_right "No tables has records" "[    Updating ... $KEYSPACE    ]"
        for TABLE_CSV in $TABLES_CSV; do
            TABLE=`basename -s.csv $TABLE_CSV`
            cqlsh -e "COPY $KEYSPACE.$TABLE FROM '$TABLE_CSV' WITH NULL = 'null'"
        done
    else
        echo Not updating keyspace since $TABLE_WHICH_HAS_DATA has data
    fi
done

popd
rm -r $TMP_DIR
