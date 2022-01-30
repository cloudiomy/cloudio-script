#!/bin/bash
# Auto Delete expired 
# Script     : r4r3
# Author     : rizqi_pro,kedai_rare ✵✫ 𝑆𝐼𝑁𝐶𝐸 2021 ✫✵
# =========================
#EDITMYIP
MYIP3=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
# check izin
CEKIZIN () {
    IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $MYIP3)
    if [[ "${MYIP3}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    else
    clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please contact admin to purchase Script License - Contact Telegram @cloudio_admin"
    exit 0
    fi

}

CEKIZIN
####################################################################


# delete expired user ovpn
echo -e "[ Info ] Check expired delete"
sleep 2
delete
# delete expired user ssr,ss,wg,trojan
echo -e "[ Info ] Check expired xp"
sleep 2
xp
# delete expired user xray
echo -e "[ Info ] Check expired xray-xp"
sleep 2
xray-xp
# delete expired user v2ray
echo -e "[ Info ] Check expired v2ray-xp"
sleep 2
v2ray-xp
# clear log every day (xray,v2ray,trojan)
echo -e "[ Info ] Check clear-log"
sleep 2
clear-log
# traffic upload
echo -e "[ Info ] Check traffic-log"
sleep 2
traffic-log
# selesai
echo -e "[ OK ] Check expired selesai"
sleep 2
echo -e "[ OK ] Check Xray Core update"
curl --silent https://api.github.com/repos/XTLS/Xray-core/releases | jq -r '.[]|select (.prerelease==false)|.tag_name' | head -1  > /home/xray-ver && &>/dev/null
sleep 2
echo -e "[ OK ] Check V2ray Core update"
curl --silent https://api.github.com/repos/v2fly/v2ray-core/releases | jq -r '.[]|select (.prerelease==false)|.tag_name' | head -1  > /home/v2ray-ver && &>/dev/null
sleep 2
