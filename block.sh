if [ ! -d "serverdata" ]; then
   ./update-db.sh
fi

counter=0;
dialogstring=''

for filename in `ls serverdata`; do
   (( counter++ ))
   dialogstring=$dialogstring" "$counter" "$filename" off"
done

result=`dialog --stdout --checklist "Choose servers to block: " 30 40 $counter $dialogstring`

counter=0;
for filename in `ls serverdata`; do
   (( counter++ ))
   for number in $result; do
      if [ "$number" -eq "$counter" ]; then
         for ip in `cat serverdata/$filename`; do
            sudo iptables -A INPUT -s $ip -j DROP
         done
      fi
   done
done
