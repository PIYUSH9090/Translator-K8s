#StopSentimentAnalyzer.sh
#If you want to stop and log off for the day.

CURRENT_DIR=`pwd`
echo "Stopping 3 components"
cd translator-frontend
sh StopTranslatorFrontendLocalNginx.sh >> ../logs/translator-frontend.log
echo "Stopped translator-frontend. Do tail -f logs/translator-frontend.log from "+$CURRENT_DIR
cd ../sa-logic
sh StopSaLogicLocally.sh >> ../logs/sa-logic.log
echo "Stopped sa-logic. Do tail -f logs/sa-logic.log from "+$CURRENT_DIR
cd ../sa-webapp
sh StopSaWebAppLocally.sh >> ../logs/sa-webapp.log
echo "Stopped sa-webapp. Do tail -f logs/sa-webapp.log from "+$CURRENT_DIR
cd ../