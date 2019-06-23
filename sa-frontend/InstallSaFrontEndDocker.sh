unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
echo "CURRENT_DATE:"+$CURRENT_DATE
sh StopSaFrontendDocker.sh
sh StopSaFrontEndLocalNginx.sh
sh clearNode.sh
#sudo brew services stop nginx
#TODO replace time with date and mode with docker
sed -ie 's/mode/docker/g' public/index.html
sed -ie 's/current_time/'$CURRENT_DATE'/g' public/index.html
npm run build
#https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/
docker push $DOCKER_USER_ID/sentiment-analysis-frontend
docker pull $DOCKER_USER_ID/sentiment-analysis-frontend
sed -ie 's/docker/mode/g' public/index.html
echo "Replacing :"$CURRENT_DATE" With current_time"
sed -ie 's/'$CURRENT_DATE'/current_time/g' public/index.html
docker run -d -p 80:80 $DOCKER_USER_ID/sentiment-analysis-frontend
echo "List of containers running now"
docker container ls -a
echo "Opening the sa-frontend"

open -a "Google Chrome" --args --incognito "http://localhost:80"
sleep 10
open -a "Google Chrome" --args --incognito "http://localhost:80"
sleep 10