#!/bin/bash
#!/bin/bash
# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
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
    Exp="[ ERROR ] SCRIPT ANDA EXPIRED!"
    else
    Exp="$Exp1"
    diff=$((($(date -d "${Exp1}" +%s)-$(date +%s))/(86400)))
    diff2="\e[31mExpired in $diff days\e[0m"
    fi

}

# check Lifetime script
CEKLifetime () {
    if [[ "${Exp1}" == "Lifetime" ]]; then
    Exp="Lifetime"
    diff2="🔥"
    else
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
    echo -e "[ ERROR ] Access is denied! Your IP $VPSIP"
    echo -e "[ Info ] Please Contact Admin  # NAK DAFTAR IP ? CONTACT SAYA @cloudio_admin DI TELEGRAM"
    accesd="echo -e [ ERROR ] Access is denied! Your IP $VPSIP"
    fi

}

CEKIZIN
####################################################################


# VPS Information
#Domain
domain=$(cat /etc/rare/xray/domain)
#Status certificate
modifyTime=$(cat /etc/rare/tls/domainexp.log | awk '{print $1" "$2" "$3" "$4}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
tlsexpdate=$(date -d +${remainingDays}days +%d-%m-%Y)
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
ceketh0=$(ip -o $ANU -4 route show to default | awk '{print $5}')
#Download/Upload today
dtoday="$(vnstat -i $ceketh0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i $ceketh0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i $ceketh0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i $ceketh0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i $ceketh0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i $ceketh0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
cekubun=$(hostnamectl | grep "Operating System" | cut -d ' ' -f5)
if [[ "${cekubun}" == "Ubuntu" ]]; then
   vdate=`date +%Y-%m`
   dmon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $2" "substr ($3, 1, 1)}')"
   umon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $5" "substr ($6, 1, 1)}')"
   tmon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $8" "substr ($9, 1, 1)}')"
else
   vdate=`date +"%b '%y"`
   dmon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $3" "substr ($4, 1, 1)}')"
   umon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $6" "substr ($7, 1, 1)}')"
   tmon="$(vnstat -i $ceketh0 -m | grep "${vdate}" | awk '{print $9" "substr ($10, 1, 1)}')"
fi
# Getting CPU Information
corediilik="$(grep -c "^processor" /proc/cpuinfo)" 
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(grep -o '"isp":"[^"]*' /root/infovps | grep -o '[^"]*$')
CITY=$(grep -o '"city":"[^"]*' /root/infovps | grep -o '[^"]*$')
WKT=$(timedatectl | grep "Time zone" |  awk '{print $3}')
tele=$(cat /home/contact)
DAY=$(date +%A)
today2=$(date +%Y-%m-%d)
DATE=$(date -d"${today2}" "+%d %b %Y")
time=$(timedatectl | grep "Local time" | awk '{print $5" "$6}')
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
# check os
cekaws=$( grep -o '"isp":"[^"]*' /root/infovps | grep -o '[^"]*$' | awk '{print $1}' )
if [[ "${cekaws}" == "Amazon.com," ]]; then
        if [[ "$(df -h | grep /dev/xvda1 | awk '{print $2}' | head -n 1 | wc -l)" = '1' ]]; then
            disktotl=$( df -h | grep /dev/xvda1 | awk '{print $2}' | head -n 1 )
            diskused=$( df -h | grep /dev/xvda1 | awk '{print $3}' | head -n 1 )
            diskfree=$( df -h | grep /dev/xvda1 | awk '{print $4}' | head -n 1 )
        else
           disktotl=$( df -h | grep /dev/root | awk '{print $2}' | head -n 1 )
           diskused=$( df -h | grep /dev/root | awk '{print $3}' | head -n 1 )
           diskfree=$( df -h | grep /dev/root | awk '{print $4}' | head -n 1 )
        fi
	else
    disktotl=$( df -h | grep /dev/vda1 | awk '{print $2}' | head -n 1 )
    diskused=$( df -h | grep /dev/vda1 | awk '{print $3}' | head -n 1 )
    diskfree=$( df -h | grep /dev/vda1 | awk '{print $4}' | head -n 1 )
fi

# total user
totalxray=$(wc -l /etc/rare/xray/clients.txt | awk '{print $1}')
totalv2ray=$(wc -l /etc/rare/v2ray/clients.txt | awk '{print $1}')
totalssh=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
totlUSR=$(($totalxray + $totalv2ray + $totalssh))

# script version check
SCnewversion=$(curl -s https://raw.githubusercontent.com/cloudiomy/v3/main/1versi)
SColdversion=$(cat /home/version)
if [[ "${SCnewversion}" == "${SColdversion}" ]]; then
    oldver=""
    else
    SCnewver="${SCnewversion}"
    SCnewver1=" echo -e [ Info ] \e[5mVersi Script Terbaru ${SCnewver} \e[0m"
fi
Name=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | grep $VPSIP | awk '{print $2}')

# dns check
curl -s http://ip-api.com/json/ > /usr/sbin/infodns
ISPDNS=$(grep -o '"isp":"[^"]*' /usr/sbin/infodns | grep -o '[^"]*$')
CITYDNS=$(grep -o '"city":"[^"]*' /usr/sbin/infodns | grep -o '[^"]*$')
DNSIP=$(grep -o '"query":"[^"]*' /usr/sbin/infodns | grep -o '[^"]*$')
VPSIP=$(grep -o '"query":"[^"]*' /usr/sbin/infovps | grep -o '[^"]*$')
if [[ "${DNSIP}" == "${VPSIP}" ]]; then
    dnsok=""
    else
    dnsinfo1='echo -e \e[0m[ INFO ] DNS'
    dnsinfo2="echo Ip DNS               :  $DNSIP"
    dnsinfo3="echo Isp Name             :  $ISPDNS"
    dnsinfo4="echo City                 :  $CITYDNS"
    dnsinfo5="mlinecolour"
fi

######### theme
#banner1=$(cat /root/themes/banner)
#[[ ! -f /root/themes/cbanner ]] && echo "\e[33m" > /root/themes/cbanner
#cbann=$(cat /root/themes/cbanner) # echo "\e[33m" > /root/themes/cbanner
# menu lol
# menu lol
menuline=$(cat /root/theme/menuline)
menuline2=$(cat /root/theme/menuline2)
fonts=$(cat /root/theme/fonts)
banname=$(cat /root/theme/banname)
ban2name=$(cat /root/theme/ban2name)
c1=$(cat /root/theme/menucolour1)
c2=$(cat /root/theme/menucolour2)
c3=$(cat /root/theme/menucolour3)
c4=$(cat /root/theme/menucolour4)
c5=$(cat /root/theme/menucolour5)
c6=$(cat /root/theme/menucolour6)
cline=$(cat /root/theme/mlinecolour)
################

# menu
clear
#echo -e "${cbann}${banner1}"
colourbanner "$banname"
mlinecolour
menucolour1 "CPU Model              \e[0m:   $cname"
menucolour1 "Operating System       \e[0m:    "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
menucolour1 "System Uptime          \e[0m:    $uptime "
menucolour1 "ISP Name               \e[0m:    $ISP"
menucolour1 "Domain                 \e[0m:    $domain"	
menucolour1 "IPv4                   \e[0m:    $VPSIP"	
menucolour1 "City                   \e[0m:    $CITY"
menucolour1 "Time                   \e[0m:    $time $WKT"
menucolour1 "Date                   \e[0m:    $DAY $DATE"
menucolour1 "Script Version         \e[0m:    V3 (22.02.2022)"
menucolour1 "Domain Cert status     \e[0m:    \033[0;36mExpired in ${tlsStatus} days($tlsexpdate)\e[0m"
mlinecolour
$dnsinfo1
$dnsinfo2
$dnsinfo3
$dnsinfo4
$dnsinfo5
menucolour2 "Disk/RAM          RAM          DISK        CPU INFO\e[0m"
menucolour2 "Total\e[0m            $tram MB        $disktotl        $freq MHz  \e[0m"
menucolour2 "Used\e[0m             ${red}$uram MB         $diskused\e[0m         $cpu_usage"
menucolour2 "Free\e[0m             $fram MB        $diskfree         $cores Cores \e[0m"
mlinecolour
menucolour3 "Traffic          Today         Yesterday        Month   \e[0m"
menucolour3 "Download\e[0m         $dtoday       $dyest          $dmon   \e[0m"
menucolour3 "Upload\e[0m           $utoday       $uyest          $umon   \e[0m"
menucolour3 "Total\e[0m          \033[0;36m  $ttoday       $tyest          $tmon  \e[0m "
mlinecolour
menucolour4 "TOTAL USER          OVPN          XRAY          V2RAY   \e[0m"
echo -e "      $totlUSR             $totalssh             $totalxray             $totalv2ray   \e[0m"
mlinecolour
menucolour4 "                       ⚡️ MENU VPS ⚡️
  ${c6}[${c5}•1${c6}]  •  SSH & OpenVPN Menu     ${c6}[${c5}•9${c6}]  •  VPS Information
  ${c6}[${c5}•2${c6}]  •  Wireguard Menu         ${c6}[${c5}10${c6}]  •  Script Info
  ${c6}[${c5}•3${c6}]  •  SSR & SS Menu          ${c6}[${c5}11${c6}]  •  Traffic Info
  ${c6}[${c5}•4${c6}]  •  XRAY Menu              ${c6}[${c5}12${c6}]  •  User Created History
  ${c6}[${c5}•5${c6}]  •  V2RAY Menu             ${c6}[${c5}13${c6}]  •  Clear RAM Cache
  ${c6}[${c5}•6${c6}]  •  Trojan GFW Menu        ${c6}[${c5}14${c6}]  •  BBR & TCP Tweak
  ${c6}[${c5}•7${c6}]  •  System Menu            ${c6}[${c5}15${c6}]  •  Menu Themes
  ${c6}[${c5}•8${c6}]  •  Status Service"
mlinecolour
${accesd}
menucolour4 "Client Name    \E[0m: $Name"
menucolour4 "License Expiry \E[0m: $Exp $diff2"
menucolour4 "Version        \E[0m: V3 (22.02.2022)"
mlinecolour
echo -e "Type x atau [ Ctrl+C ] •Keluar-dari-Script"
echo
read -p "► Select menu :  "  opt
echo -e   ""
case $opt in
1) m-sshovpn ;;
2) m-wg ;;
3) m-ss ;;
4) xray-menu ;;
5) v2ray-menu ;;
6) m-trojan ;;
7) m-system ;;
8) status ;;
9) vpsinfo ;;
10) info-menu ;;
11) traffic-info ;;
12) user-created ;;
13) clearcache ;;
14) tcptweaker ;;
15) m-themes ;;
x) exit ;;
*) echo "Nombor Yang Anda Masukkan Salah!" ; sleep 1 ; menu ;;
esac