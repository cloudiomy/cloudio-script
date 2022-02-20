#!/bin/bash
#####################################################################
#EDITMYIP
VPSIP=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
today=`date +"%Y-%m-%d" -d -1day"$dateFromServer"`
Exp1=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | grep $VPSIP | awk '{print $3}')
# check expired script 
CEKEXPIRED () {
    d1=(`date -d "$Exp1" +%s`)
    d2=(`date -d "$today" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))    
    if [[ "$exp2" -le "0" ]]; then # -le less or equal
    clear
    echo -e "[ ERROR ] SCRIPT ANDA EXPIRED!"
    echo -e "[ Info ] Sila contact admin untuk renew IP !! CONTACT SAYA @cloudio_admin DI TELEGRAM"
    exit 0
    else
    echo -e "[ OK ] STATUS SCRIPT AKTIF...."
    fi

}

# check Lifetime script
CEKLifetime () {
    if [[ "${Exp1}" == "Lifetime" ]]; then
    echo -e "[ OK ] STATUS SCRIPT Lifetime...."
    else
    echo -e "[ OK ] CEK STATUS SCRIPT EXPIRED ...."
    CEKEXPIRED 
    fi

}

# check izin
CEKIZIN () {
    IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $VPSIP)
    if [[ "${VPSIP}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    CEKLifetime
    else
    clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please Contact Admin  # NAK DAFTAR IP ? CONTACT SAYA @cloudio_admin DI TELEGRAM"
    exit 0
    fi

}

CEKIZIN
####################################################################


clear
c5=$(cat /root/theme/menucolour5)
c6=$(cat /root/theme/menucolour6)
c7=$(cat /root/theme/menucolour7)

mline2colour
menucolour4 "${c7}        • BACKUP & RESTORE MENU •          \e[0m"
mline2colour
menucolour4 "
 ${c6}[${c5}•1${c6}] Set Auto-Backup Data VPS
 ${c6}[${c5}•2${c6}] Backup Data VPS
 ${c6}[${c5}•3${c6}] VPS Backup Info
 ${c6}[${c5}•4${c6}] Restore Data VPS

 ${c6}[${c5}•0${c6}] \e[31mBACK TO MENU\033[0m"
mline2colour
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