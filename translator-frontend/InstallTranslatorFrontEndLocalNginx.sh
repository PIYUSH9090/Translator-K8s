#deployToLocalNginx.sh
#Run it as sh deployToLocal.sh > deployToLocal.log &
#echo <password> | sudo -S <command>
echo "TranslatorFrontendLocalNginx:"+ `date`
sh StopTranslatorFrontendLocalNginx.sh
sh clearNode.sh
TESTDATE=`date +%b-%d-%y_%I_%M_%S_%p`
CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
NGINX_HOME="/usr/local/opt/nginx"
CURRENT=`pwd`

new_values="localhost:8080"
old_values=`cat ../oldValues.txt`
echo $new_values > ../oldValues.txt

echo $TESTDATE 
echo $NGINX_HOME

sed -ie 's/mode/local-nginx/g' public/index.html
sed -ie 's/current_time/'$CURRENT_DATE'/g' public/index.html

echo "Replacing-"$old_values"-with-"$new_values"-src/App.js"
sed -ie 's/'$old_values'/'$new_values'/g' src/App.js
cat src/App.js


cat public/index.html
npm run build

cd $NGINX_HOME
#zip ../ReportingProject_$TESTDATE ReportingProject -r . -x "*/node_modules/*"

zip $CURRENT/../Backups/NGINX-HTML_$TESTDATE html -r
#TODO: upload backups to nexus ?

ls -lrt $CURRENT/../Backups/NGINX-HTML_$TESTDATE.zip

cd $CURRENT

cp -vr build/* $NGINX_HOME/html
echo $my_pass | sudo -S sudo brew services start nginx
#sudo brew services start nginx

echo "Started nginx"

ps -ef | grep nginx &

sed -ie 's/local-nginx/mode/g' public/index.html
echo "Replacing :"$CURRENT_DATE" With current_time"
sed -ie 's/'$CURRENT_DATE'/current_time/g' public/index.html

cat public/index.html

echo "Opening the translator-frontend"

open -a "Google Chrome" --args --incognito "http://localhost:80"
sleep 10
open -a "Google Chrome" --args --incognito "http://localhost:80"
sleep 10