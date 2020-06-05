#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED RunTranslator.sh Docker ***
***************
'
    echo "An error occurred in RunTranslator.sh docker . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
#RunSentimentAnalyzerDocker.sh
CURRENT_DIR=`pwd`
CURRENT_DATE=`date +%b-%d-%y_%I_%M_%S_%p`
mkdir logs/$CURRENT_DATE
mv logs/*.log logs/$CURRENT_DATE/
echo "Starting sa-logic"
cd sa-logic
sh InstallSaLogicDocker.sh > ../logs/sa-logic.log
#sh InstallSaLogicDocker.sh
echo "Started sa-logic. Do tail -f logs/sa-logic.log from "+$CURRENT_DIR
#open -a Terminal $CURRENT_DIR/logs
echo "Starting sa-webapp"
cd ../sa-webapp
sh InstallSaWebAppDocker.sh > ../logs/sa-webapp.log
#sh InstallSaWebAppDocker.sh
#open -a Terminal $CURRENT_DIR/logs
echo "Started sa-webapp. Do tail -f logs/sa-webapp.log from "+$CURRENT_DIR
echo "Starting sa-frontend"
cd ../translator-frontend
sh InstallTranslatorFrontEndCompleteDocker.sh > ../logs/translator-frontend.log
#sh InstallTranslatorFrontEndCompleteDocker.sh > ../logs/translator-frontend.log
#sh InstallSaFrontEndDocker.sh
echo "Started translator-frontend. Do tail -f logs/translator-frontend.log from "+$CURRENT_DIR
#open -a Terminal $CURRENT_DIR/logs
cd ../
pwd

trap : 0

echo >&2 '
************
*** DONE RunTranslatorDocker ***
************'
