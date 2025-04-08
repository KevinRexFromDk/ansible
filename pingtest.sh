LOGFILE="ping.log"
IP=""

while true; do
    if ping -s 65500  -c 1 -w 1 "$IP" > /dev/null; then
        DATE=$(date '+%Y%m%d%H%M%S')
        #echo "$DATE - Ping to $IP successful"
    else
        DATE=$(date '+%Y%m%d%H%M%S')
        echo "Malfunction detected: $DATE" >> $LOGFILE
        echo "Malfunction detected: $DATE"
    fi
    #sleep 1
done
