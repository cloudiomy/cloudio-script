#!/bin/bash
blink='\e[5m'
DF='\e[39m'
NC='\e[0m'
#EDITMYIP
VPSIP=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
echo "Checking VPS"

IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $VPSIP)
if [[ "${VPSIP}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    sleep 2
else
	clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please Contact Admin  # NAK DAFTAR IP ? CONTACT SAYA @cloudio_admin DI TELEGRAM "
    exit 0
fi
date=`date`
echo `date`
#cpu use threshold
cpu_threshold='70'
 #mem idle threshold
mem_threshold='100'
 #disk use threshold
disk_threshold='90'
#---cpu
cpu_usage () {
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
 echo "CPU utilization: $cpu_usage"
if [ $cpu_usage -gt $cpu_threshold ]
    then
        echo "cpu warning!!!"
        echo "cpu warning!!! $date" >> /root/reboot.log
        reboot
    else
        echo "CPU ok!!!"
fi
}
#---mem
mem_usage () {
 #MB units
mem_free=`free -m | grep "Mem" | awk '{print $4+$6}'`
 echo "Memory space remaining : $mem_free MB"
if [ $mem_free -lt $mem_threshold  ]
    then
        echo "mem warning!!!"
        echo "mem warning!!! $date" >> /root/reboot.log
        reboot
    else
        echo "Memory space ok!!!"
fi
}

today2=$(date +%Y-%m-%d)
DATE=$(date -d"${today2}" "+%d %b %Y")
time=$(timedatectl | grep "Local time" | awk '{print $5" "$6}')
echo "" >>/root/CPU_check.log
echo "-------------------------------------" >>/root/CPU_check.log
echo "CPU check mula `date`" >>/root/CPU_check.log
echo "-------------------------------------" >>/root/CPU_check.log
mem_usage
cpu_usage
echo "Selesai" >>/root/CPU_check.log