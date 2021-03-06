#!/bin/sh

abort()
{
    echo >&2 '
***************
*** ABORTED InstallSaWebAppLocally.sh ***
***************
'
    echo "An error occurred InstallSaWebAppDocker . Exiting..." >&2
    exit 1
}
#InstallSaWebAppDocker.sh
LEVEL=NONDEBUG
if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG.Press Enter to continue."
	read levelIsDebug	
else
	echo "Level is NOT DEBUG. There will be no wait."	
fi
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "Trying to login. If you are NOT logged in, there will be a prompt"
docker login

echo "InstallSaWebAppDocker at" `date`
SA_LOGIC_CONTAINER_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -f ancestor=maheshrajannan/sentiment-analysis-logic -aq)`
echo "SA_LOGIC_CONTAINER_IP:" $SA_LOGIC_CONTAINER_IP
SA_LOGIC_API_URL='http://'$SA_LOGIC_CONTAINER_IP":5000"
echo "SA_LOGIC_API_URL:"$SA_LOGIC_API_URL
#sh StopSaWebAppLocally.sh
#sh StopSaWebAppDocker.sh
if [ "$LEVEL" == "DEBUG" ]; then
	read -p "SA_LOGIC_API_URL Looks right ?"
fi
echo "Running sentiment-analysis-web-app:"
docker run -d -p 8080:8080 -e SA_LOGIC_API_URL=$SA_LOGIC_API_URL maheshrajannan/sentiment-analysis-web-app
sleep 5
echo "List of containers running now"
docker container ls -a
saWebAppId="$(docker container ls -f ancestor="maheshrajannan/sentiment-analysis-web-app" -f status=running -aq)"
echo " The one we just started is : $saWebAppId"

if [ -n "$saWebAppId" ]; then
  echo "sentiment_analysis_web container is running $(docker container ls -f ancestor=maheshrajannan/sentiment-analysis-web-app -f status=running -aq) :) "
else
  echo "ERROR: sentiment_analysis_web is NOT running. :(  . Please Check logs/sa-webapp.log"
  exit 1
fi

echo >&2 '
************
*** DONE InstallSaWebAppDocker.sh ***
************'