#!/bin/bash
#####################################################################
#EDITMYIP
MYIP3=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
today=`date +"%Y-%m-%d" -d -1day"$dateFromServer"`
Exp1=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | grep $MYIP3 | awk '{print $3}')
# check expired script 
CEKEXPIRED () {
    d1=(`date -d "$Exp1" +%s`)
    d2=(`date -d "$today" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))    
    if [[ "$exp2" -le "0" ]]; then # -le less or equal
    clear
    echo -e "[ ERROR ] Your license expired!"
    echo -e "[ Info ] Please contact admin for IP Renewal - Contact Telegram @cloudio_admin"
    exit 0
    else
    echo -e "[ OK ] STATUS SCRIPT ACTIVE..."
    fi

}

# check Lifetime script
CEKLifetime () {
    if [[ "${Exp1}" == "Lifetime" ]]; then
    echo -e "[ OK ] STATUS SCRIPT LIFETIME..."
    else
    echo -e "[ OK ] CHECK STATUS SCRIPT EXPIRED..."
    CEKEXPIRED 
    fi

}

# check izin
CEKIZIN () {
    IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $MYIP3)
    if [[ "${MYIP3}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    CEKLifetime
    else
    clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please contact admin to purchase Script License - Contact Telegram @cloudio_admin"
    exit 0
    fi

}
####################################################################

CEKIZIN

clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m     • BACKUP & RESTORE MENU •     \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m•1\e[0m] Set Auto-Backup Data VPS"
echo -e " [\e[36m•2\e[0m] Backup Data VPS"
echo -e " [\e[36m•3\e[0m] VPS Backup Info"
echo -e " [\e[36m•4\e[0m] Restore Data VPS"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Type x atau [ Ctrl+C ] •Keluar-dari-Script"
echo -e ""
read -p "► Select menu : " opt
echo -e ""
case $opt in
1) clear ; autobackup-setup ; exit ;; #set.br
2) clear ; backup ; exit ;; #set.br
3) clear ; backup-info ; exit ;; #set.br
4) clear ; restore ; exit ;; #set.br
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "" ; echo "Nombor Yang Anda Masukkan Salah!" ; sleep 1 ; m-backup ;;
esac