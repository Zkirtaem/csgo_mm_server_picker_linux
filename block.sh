if [ ! -d "serverdata" ]; then
   ./update-db.sh
fi

counter=0;
dialogstring=''
iptables_rules=`sudo iptables --list INPUT | tail -n +3 | awk '{print $4}'`

for filename in `ls serverdata`; do
   (( counter++ ))
   dialogstring=$dialogstring" "$counter" "$filename

   is_ip_locked="false"
   for iptables_ip in $iptables_rules; do
      for file_ip in `cat serverdata/$filename`; do
         if [ "$iptables_ip" == "$file_ip" ]; then
            is_ip_locked="true"
         fi
      done
   done
   if [ "$is_ip_locked" == "true" ]; then
      dialogstring=$dialogstring" on"
   else
      dialogstring=$dialogstring" off"
   fi
done

result=`dialog --stdout --checklist "Choose servers to block: " 30 40 $counter $dialogstring`
counter=0;

for filename in `ls serverdata`; do
   for ip in `cat serverdata/$filename`; do
      sudo iptables -D INPUT -s $ip -j DROP 2> /dev/null
   done
done

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
