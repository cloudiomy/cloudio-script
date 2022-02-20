#!/bin/bash
# Script     : r4r3
# Author     : rizqi_pro,kedai_rare ✵✫ 𝑆𝐼𝑁𝐶𝐸 2021 ✫✵
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

####################################################################

alamat_ip=$(wget -qO- ipv4.icanhazip.com)

echo -e "[ Creating ] Squid conf"
sleep 2
echo "acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl Safe_ports port 80
acl Safe_ports port 88
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 8443
acl Safe_ports port 8888
acl Safe_ports port 8080
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl Safe_ports port 444
acl CONNECT method CONNECT
acl SSH dst $alamat_ip-$alamat_ip/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8000
http_port 3128
dns_v4_first on
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname vpnshopee" > /etc/squid/squid.conf

echo -e "[ Info ] Restart squid service"
sleep 2
/etc/init.d/squid restart
echo -e "[ Info ] Pemasangan squid config telah selesai"
sleep 2
