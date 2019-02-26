#!/usr/bin/env bash
cd /opt/  \
&& git clone https://github.com/sohutv/cachecloud \
&& DB_URL=${DB_URL=127.0.0.1} \
&& DB_PORT=${DB_PORT=3306} \
&& DB_NAME=${DB_NAME=cachecloud} \
&& DB_USER=${DB_USER=root} \
&& DB_PASSWORD=${DB_PASSWORD=123456789} \
&& WEB_PORT=${WEB_PORT=8585} \
&& cd cachecloud \
&& sed -i "s#^cachecloud.db.url.*#cachecloud.db.url=jdbc:mysql://$DB_URL:$DB_PORT/$DB_NAME#g" \
 ./cachecloud-open-web/src/main/swap/online.properties \
&& sed -i "s#^cachecloud.db.user.*#cachecloud.db.user = $DB_USER#g" \
 ./cachecloud-open-web/src/main/swap/online.properties \
&& sed -i "s#^cachecloud.db.password.*#cachecloud.db.password = $DB_PASSWORD#g" \
 ./cachecloud-open-web/src/main/swap/online.properties \
&& sed -i "s#^web.port.*#web.port=$WEB_PORT#g" \
 ./cachecloud-open-web/src/main/swap/online.properties \
&& mvn clean compile install -Ponline \
&& mkdir -p /opt/cachecloud-web \
&& cp cachecloud-open-web/target/cachecloud-open-web-1.0-SNAPSHOT.war /opt/cachecloud-web/ \
&& cp cachecloud-open-web/src/main/resources/cachecloud-web.conf /opt/cachecloud-web/ \
&& chmod +x ./script/*  \
&& mkdir -p /opt/cachecloud-web/logs/ \
&& JAVA_OPTS="-server -Xmx3g -Xms3g -Xss256k -XX:MaxDirectMemorySize=1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:G1ReservePercent=25 -XX:InitiatingHeapOccupancyPercent=40 -XX:+PrintGCDateStamps -Xloggc:/opt/cachecloud-web/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/cachecloud-web/logs/java.hprof -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -XX:+PrintCommandLineFlags -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Djava.util.Arrays.useLegacyMergeSort=true -Dfile.encoding=UTF-8" \
&& sed -i "s#^JAVA_OPTS.*#JAVA_OPTS=\"$JAVA_OPTS\"#g" \
  ./script/start.sh \
&& ./script/start.sh
