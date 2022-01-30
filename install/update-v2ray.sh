#!/bin/bash
# V2ray Auto Setup 
# Script     : r4r3
# Author     : rizqi_pro,kedai_rare ✵✫ 𝑆𝐼𝑁𝐶𝐸 2021 ✫✵
# =========================
#EDITMYIP
MYIP3=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
echo "Checking VPS"
useripgit=$(cat /home/userip-git)
usergit=$(cat /home/user-git) 

# check expired script
CEKEXPIRED () {
    today=$(date -d -1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | grep $MYIP3 | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "[ OK ] STATUS SCRIPT ACTIVE..."
    else
    clear
    echo -e "[ ERROR ] Your license expired!"
    echo -e "[ Info ] Please contact admin for IP Renewal - Contact Telegram @cloudio_admin"
    exit 0
fi
}

# check izin
IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $MYIP3)
if [[ "${MYIP3}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    CEKEXPIRED
else
	clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please contact admin to purchase Script License - Contact Telegram @cloudio_admin"
    exit 0
fi


clear
# colour info
green="\033[32m" && red="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && NC="\e[0m"
info="[ ${green}INFORMATION${NC} ]"
ok="[ ${green}OK${NC} ]"
Error="${red}[error]${NC}"
Tip="${green}[note]${NC}"

echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m     • UPDATE V2RAY CORE •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
# CHECK VERSION
newversion=$(cat /home/v2ray-ver)
oldversion=$(cat /etc/rare/v2ray/version)
if [[ "${newversion}" == "${oldversion}" ]]; then
	echo -e ""
    echo "YOUR VERSION IS LATEST VERSION ${newversion}"
    echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
v2ray-menu 
elif [[ "$num" = "n" ]]; then
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
exit 0
else
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
exit 0
fi