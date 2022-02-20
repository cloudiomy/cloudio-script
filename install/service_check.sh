#!/bin/bash
# Script     : r4r3
# Author     : rizqi_pro,kedai_rare ✵✫ 𝑆𝐼𝑁𝐶𝐸 2021 ✫✵
#####################################################################
red='\e[31m'
GR='\e[0;32m'
NC='\e[0m'
DF='\e[39m'
#EDITMYIP
VPSIP=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
echo "Checking VPS"
#useripgit=$(cat /home/userip-git)
#usergit=$(cat /home/user-git)
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
####################################################################

CEKIZIN

clear

rsleep=$((1 + $RANDOM % 55))
sleep 1m
sleep ${rsleep}

# status
pok='[ \033[32mok\e[0m ]'
pko='[ \e[31m❌\e[0m ]'

#  service_check.sh 
# echo "0 */6 * * * root /usr/bin/service_check # every 6th hour" >> /etc/crontab
#1 1 * * 0  /usr/bin/curl -m 120 -s http://example.come/some.php &>/dev/null
# Chek Status 
today2=$(date +%Y-%m-%d)
DATE=$(date -d"${today2}" "+%d %b %Y")
time=$(timedatectl | grep "Local time" | awk '{print $5" "$6}')

echo "" >>/root/service_check.log
echo "-------------------------------------" >>/root/service_check.log
echo "Service check mula $DATE $time" >>/root/service_check.log
echo "-------------------------------------" >>/root/service_check.log

# Status Service SSH
echo [ INFO ] Check Status Service SSH
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $ssh_service == "running" ]]; then 
   status_ssh="Running $pok"
else
   systemctl restart ssh
   echo "Restart SSH" >>/root/service_check.log
fi

# Status Service OpenVPN
echo [ INFO ] Check Status Service OpenVPN
openvpn_service="$(systemctl show openvpn.service --no-page)"
oovpn=$(echo "${openvpn_service}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $oovpn == "active" ]]; then
  status_openvpn="Running $pok"
else
  systemctl restart openvpn
  echo "Restart OpenVPN" >>/root/service_check.log
fi

# Status Service OHP
echo [ INFO ] Check Status Service OHP
ohp_service="$(systemctl show ohp.service --no-page)"
ohpovpn=$(echo "${ohp_service}" | grep 'ActiveState=' | cut -f2 -d=)
if [[ $ohpovpn == "active" ]]; then
  status_OHPovpn="Running $pok"
else
  systemctl restart ohp.service
  echo "Restart OHP" >>/root/service_check.log
fi

# Status Service Dropbear
echo [ INFO ] Check Status Service Dropbear
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $dropbear_status == "running" ]]; then 
   status_dropbear="Running $pok"
else
   systemctl restart dropbear
   echo "Restart Dropbear" >>/root/service_check.log
fi

# Status Service Stunnel
echo [ INFO ] Check Status Service Stunnel
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $stunnel_service == "running" ]]; then 
   status_stunnel="Running $pok"
else
   systemctl restart stunnel4
   echo "Restart Stunnel" >>/root/service_check.log
fi

# Status Service  Squid 
echo [ INFO ] Check Status Service  Squid
squid_service=$(/etc/init.d/squid status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $squid_service == "running" ]]; then 
   status_squid="Running $pok"
else
   systemctl restart squid
   echo "Restart squid" >>/root/service_check.log
fi

# Status Service  Fail2ban
echo [ INFO ] Check Status Service  Fail2ban
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $fail2ban_service == "running" ]]; then 
   status_fail2ban="Running $pok"
else
   systemctl restart fail2ban
   echo "Restart Fail2ban" >>/root/service_check.log
fi

# Status Service Crons
echo [ INFO ] Check Status Service Crons
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $cron_service == "running" ]]; then 
   status_cron="Running $pok"
else
   systemctl restart cron
   echo "Restart Cron" >>/root/service_check.log
fi

# Status Service VNSTAT
echo [ INFO ] Check Status Service VNSTAT
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $vnstat_service == "running" ]]; then 
   status_vnstat="Running $pok"
else
   systemctl restart vnstat
   echo "Restart VNSTAT" >>/root/service_check.log
fi

# Status Service NGINX
echo [ INFO ] Check Status Service NGINX
nginx_status=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $nginx_status == "running" ]]; then 
   status_nginx="Running $pok"
else
   systemctl restart nginx
   echo "Restart NGINX" >>/root/service_check.log
fi

# Status Service XTLS XRAY
echo [ INFO ] Check Status Service XTLS XRAY
xtls_xray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xtls_xray_status == "running" ]]; then 
   status_xtls_xray="Running $pok"
else
   systemctl restart xray
   systemctl restart xray.service
   echo "Restart XRAY" >>/root/service_check.log
fi

# Status Service TLS V2RAY
echo [ INFO ] Check Status Service TLS V2RAY
tls_v2ray_status=$(systemctl status v2ray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray="Running $pok"
else
   systemctl restart v2ray
   systemctl restart v2ray.service
   echo "Restart V2RAY" >>/root/service_check.log
fi

# Shadowsocks-R Status
echo [ INFO ] Check Shadowsocks-R Status
ssr_status=$(systemctl status ssrmu | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $ssr_status == "active" ]] ; then
  status_ssr="Running $pok"
else
  systemctl restart ssrmu
  echo "Restart Shadowsocks-R" >>/root/service_check.log
fi

# Shadowsocks Status
echo [ INFO ] Check Shadowsocks Status
# status="$(systemctl show shadowsocks-libev.service --no-page)"
# status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
status_ss=$(systemctl status shadowsocks-libev.service | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $status_ss == "active" ]] ; then
  status_sodosok="Running $pok"
else
  systemctl restart shadowsocks-libev.service
  echo "Restart Shadowsocks" >>/root/service_check.log
fi

# Status Service Trojan-GFW
echo [ INFO ] Check Status Service Trojan-GFW
trojan_status=$(systemctl status trojan | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $trojan_status == "running" ]]; then 
   status_trojan="Running $pok"
else
   systemctl restart trojan
   echo "Restart Trojan-GFW" >>/root/service_check.log
fi

# Status Service Wireguard
echo [ INFO ] Check Status Service Wireguard
wg_status=$(systemctl status wg-quick@wg0.service | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1) 
if [[ $wg_status == "active" ]]; then
  status_wg="Running $pok"
else
  systemctl restart wg-quick@wg0.service
  echo "Restart Wireguard" >>/root/service_check.log
fi

# Status Service DDoS-Deflate
echo [ INFO ] Check Status Service DDoS-Deflate
ddos_status=$(systemctl status ddos | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $ddos_status == "running" ]]; then 
   status_ddos="Running $pok"
else
   systemctl restart ddos
   echo "Restart DDoS-Deflate" >>/root/service_check.log
fi

echo [ OK ] Check Status Service Selesai
echo "Service check selesai" >>/root/service_check.log
echo "" >>/root/service_check.log
