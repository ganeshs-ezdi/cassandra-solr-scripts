#! /bin/bash

SOLR_PATH=/opt/solr
SOLR_COULD_SCRIPT_PATH=$SOLR_PATH/server/scripts/cloud_scripts
ZKHOST=$1
CONFDIR=$2

CONFIGS="CCPhysician DocumentMaster MacrosSuggester MtDocumentMaster RefDocumentSearchh CNTDocumentMaster NewNPDocumentMaster SpellCheck UserMaster AdtSearch"

for CONFNAME in $CONFIGS; do
    echo Downloading configuration $CONFNAME from $ZKHOST to $CONFDIR/$CONFNAME
    $SOLR_COULD_SCRIPT_PATH/zkcli.sh -cmd downconfig -zkhost $ZKHOST -confname $CONFNAME -d $CONFDIR/$CONFNAME
done
