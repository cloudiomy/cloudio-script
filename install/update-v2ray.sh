#!/bin/bash
# V2ray Auto Setup 
# Script     : r4r3
# Author     : rizqi_pro,kedai_rare ✵✫ 𝑆𝐼𝑁𝐶𝐸 2021 ✫✵
# ========================
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
c5=$(cat /root/theme/menucolour5)
c6=$(cat /root/theme/menucolour6)
c7=$(cat /root/theme/menucolour7)

# colour info
green="\033[32m" && red="\033[31m" && GR_BACK="\033[42;37m" && RED_BACK="\033[41;37m" && NC="\e[0m"
info="[ ${GR}INFORMATION${NC} ]"
ok="[ ${GR}OK${NC} ]"
Error="${red}[error]${NC}"
Tip="${GR}[note]${NC}"

# menu
mline2colour
menucolour4 "${c7}          • UPDATE V2RAY CORE •            \e[0m"
mline2colour
# CHECK VERSION
newversion=$(cat /home/v2ray-ver)
oldversion=$(cat /etc/rare/v2ray/version)
if [[ "${newversion}" == "${oldversion}" ]]; then
	echo -e ""
    echo "YOUR VERSION IS LATEST VERSION ${newversion}"
    echo -e ""
else
	echo -e ""
    echo "YOUR VERSION IS ${oldversion}"
    echo "LATEST VERSION IS ${newversion}"
    echo -e ""
fi

read -r -p "Update V2ray core anda ？[y/n]
Enter jika anda tidak tahu : " -e num
if [[ "$num" = "y" ]]; then
echo -e ""
echo -e $info PROSES UPDATE MULA
sleep 2
# MOVE CONFIG TO TEMP
mv /etc/rare/v2ray/conf /etc/rare/temp/conf
mv /etc/rare/v2ray/clients.txt /etc/rare/temp
rm -rf /etc/rare/v2ray/*
systemctl stop v2ray >/dev/null
rm -f /etc/systemd/system/v2ray.service
systemctl daemon-reload
echo -e $info Download V2ray Core ${newversion}
sleep 2
# DOWNLOAD V2RAY CORE
echo "$newversion" > /etc/rare/v2ray/version
wget -c -P /etc/rare/v2ray/ "https://github.com/v2fly/v2ray-core/releases/download/$newversion/v2ray-linux-64.zip" &> /dev/null
unzip -o /etc/rare/v2ray/v2ray-linux-64.zip -d /etc/rare/v2ray &> /dev/null
rm -rf /etc/rare/v2ray/v2ray-linux-64.zip &> /dev/null
# v2ray boot service
echo -e $info Konfigurasi systemd v2ray service
rm -rf /etc/systemd/system/v2ray.service
touch /etc/systemd/system/v2ray.service
cat <<EOF >/etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray - A unified platform for anti-censorship
Documentation=https://v2ray.com https://guide.v2fly.org
After=network.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=/etc/rare/v2ray/v2ray -confdir /etc/rare/v2ray/conf
Restart=on-failure
RestartPreventExitStatus=23


[Install]
WantedBy=multi-user.target
EOF
echo -e $info Enable v2ray service
systemctl daemon-reload
systemctl enable v2ray
systemctl enable v2ray.service
rm -rf /etc/rare/v2ray/conf/*
# RESTORE CONFIG
echo -e $info RESTORE USER CONFIG
mv /etc/rare/temp/conf/ /etc/rare/v2ray/conf
mv /etc/rare/temp/clients.txt /etc/rare/v2ray
echo -e $info Restart V2ray Services
systemctl daemon-reload
systemctl restart v2ray
systemctl restart v2ray.service
echo -e $info Check Status V2ray Services
# Status Service TLS V2RAY
tls_v2ray_status=$(systemctl status v2ray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray="Running [ \033[32mok\033[0m ]"
   else
   status_tls_v2ray="Not Running [ \e[31m❌\e[0m ]"
fi
echo -e $info V2ray Status $status_tls_v2ray
echo -e ""
mline2colour
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
v2ray-menu 
elif [[ "$num" = "n" ]]; then
echo -e ""
mline2colour
exit 0
else
echo -e ""
mline2colour
exit 0
fi