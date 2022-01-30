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
echo -e "\E[0;100;33m      • UPDATE XRAY CORE •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
# CHECK VERSION
newversion=$(cat /home/xray-ver)
oldversion=$(cat /etc/rare/xray/version)
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

read -r -p "Update Xray core anda ？[y/n]
Enter jika anda tidak tahu : " -e num
if [[ "$num" = "y" ]]; then
echo -e ""
echo -e $info PROSES UPDATE MULA
sleep 2
# MOVE CONFIG TO TEMP
mv /etc/rare/xray/conf /etc/rare/temp/conf
mv /etc/rare/xray/clients.txt /etc/rare/temp
mv /etc/rare/xray/xray.key /etc/rare/temp
mv /etc/rare/xray/xray.crt /etc/rare/temp
mv /etc/rare/xray/domain /etc/rare/temp
rm -rf /etc/rare/xray/*
systemctl stop xray >/dev/null
systemctl stop xray.service >/dev/null
rm -f /etc/systemd/system/xray.service
systemctl daemon-reload
echo -e $info Download Xray Core ${newversion}
sleep 2
# DOWNLOAD XRAY CORE
echo "$newversion" > /etc/rare/xray/version
wget -c -P /etc/rare/xray/ "https://github.com/XTLS/Xray-core/releases/download/$newversion/Xray-linux-64.zip" &> /dev/null
unzip -o /etc/rare/xray/Xray-linux-64.zip -d /etc/rare/xray &> /dev/null
rm -rf /etc/rare/xray/Xray-linux-64.zip &> /dev/null
chmod 655 /etc/rare/xray/xray
# Xray boot service
echo -e $info Konfigurasi systemd Xray service
touch /etc/systemd/system/xray.service
cat <<EOF >/etc/systemd/system/xray.service
[Unit]
Description=Xray - A unified platform for anti-censorship
# Documentation=https://v2ray.com https://guide.v2fly.org
After=network.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=/etc/rare/xray/xray run -confdir /etc/rare/xray/conf
Restart=on-failure
RestartPreventExitStatus=23


[Install]
WantedBy=multi-user.target
EOF
echo -e $info Enable Xray service
systemctl daemon-reload &> /dev/null
systemctl enable xray.service &> /dev/null
systemctl enable xray &> /dev/null
rm -rf /etc/rare/xray/conf/*
# RESTORE CONFIG
echo -e $info RESTORE USER CONFIG
mv /etc/rare/temp/conf/ /etc/rare/xray/conf/
mv /etc/rare/temp/clients.txt /etc/rare/xray/
mv /etc/rare/temp/xray.crt /etc/rare/xray/
mv /etc/rare/temp/xray.key /etc/rare/xray/
mv /etc/rare/temp/domain /etc/rare/xray/
echo -e $info Restart Xray Services
systemctl daemon-reload &> /dev/null
systemctl restart xray &> /dev/null
systemctl restart xray.service &> /dev/null
echo -e $info Check Status Xray Services
# Status Service XTLS XRAY
xtls_xray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xtls_xray_status == "running" ]]; then 
   status_xtls_xray="Running [ \033[32mok\033[0m ]"
else
   status_xtls_xray="Not Running [ \e[31m❌\e[0m ]"
   systemctl restart xray 
fi
echo -e $info Xray Status $status_xtls_xray
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
xray-menu 
elif [[ "$num" = "n" ]]; then
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
exit 0
else
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
exit 0
fi