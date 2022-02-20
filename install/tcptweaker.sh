#!/bin/bash
# grep -c "^#PH56" /etc/sysctl.conf = 0 STATUS OFF
# grep -c "^#PH56" /etc/sysctl.conf = 1 STATUS ON
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
# Warna status
GR="\033[32m" && red="\033[31m" && GR_BACK="\033[42;37m" && RED_BACK="\033[41;37m" && NC="\033[0m"
Info="${GR}[information]${NC}"
Error="${red}[error]${NC}"
Tip="${GR}[note]${NC}"

# status tweek
tcp_status(){
	if [[ `grep -c "^#PH56" /etc/sysctl.conf` -eq 1 ]]; then
		echo -e "TCP Tweek Current status : ${GR}Installed${NC}"
	    else
		echo -e "TCP Tweek Current status : ${red}Not Installed${NC}"
	fi
}

# status tweek
tcp_2_status(){
	if [[ `grep -c "^#GRPC" /etc/sysctl.conf` -eq 1 ]]; then
		echo -e "TCP Tweek 2 Current status : ${GR}Installed${NC}"
	    else
		echo -e "TCP Tweek 2 Current status : ${red}Not Installed${NC}"
	fi
}

# status bbr
bbr_status() {
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    if [[ x"${param}" == x"bbr" ]]; then
        echo -e "BBR Current status : ${GR}Installed${NC}"
    else
        echo -e "BBR Current status : ${red}Not Installed${NC}"
    fi
}

delete_bbr() {
   clear
   mline2colour
   menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
   mline2colour
   echo       
   read -p "Do you want to remove BBR settings? [y/n]: " -e answer0
   if [[ "$answer0" = 'y' ]]; then
      grep -v "^#RARE87
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
      sysctl -p /etc/sysctl.conf > /dev/null
      echo "cubic" >  /proc/sys/net/ipv4/tcp_congestion_control
      echo ""
      echo "BBR settings were successfully removed."
      echo ""
      read -n 1 -s -r -p "Press any key to back"        
      tcptweaker
      else 
      echo ""
      tcptweaker
    fi
}

sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "" >> /etc/sysctl.conf
    echo "#RARE87" >> /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}

check_bbr_status() {
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    if [[ x"${param}" == x"bbr" ]]; then
        return 0
    else
        return 1
    fi
}

version_ge(){
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}

check_kernel_version() {
    local kernel_version=$(uname -r | cut -d- -f1)
    if version_ge ${kernel_version} 4.9; then
        return 0
    else
        return 1
    fi
}

install_bbr2() {
    check_bbr_status
    if [ $? -eq 0 ]; then
        echo
        echo -e "[ Information ]  TCP BBR has already been installed. nothing to do..."
        echo
        read -n 1 -s -r -p "Press any key to back"        
        tcptweaker
    fi
    check_kernel_version
    if [ $? -eq 0 ]; then
        echo
        echo -e "[ Information ]  Your kernel version is greater than 4.9, directly setting TCP BBR..."
        sysctl_config
        echo -e "[ Information ]  Setting TCP BBR completed..."
        echo
        read -n 1 -s -r -p "Press any key to back"
        tcptweaker
    fi

    if [[ x"${release}" == x"centos" ]]; then
       echo ""
       echo -e "[ Invalid ] Centos not support"
       echo ""
       read -n 1 -s -r -p "Press any key to back"
       tcptweaker
    fi   
}

install_bbr() {
	clear
    mline2colour
    menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
    mline2colour
    echo
	echo "Ini adalah skrip percubaan. Gunakan atas risiko anda sendiri!"
	echo "Skrip ini akan menukar beberapa network settings"
	echo "untuk mengurangkan latency dan meningkatkan kelajuan."
	echo ""
	read -p "Proceed with installation? [y/n]: " -e answer
	if [[ "$answer" = 'y' ]]; then
	install_bbr2
    else
    echo
    read -n 1 -s -r -p "Press any key to back"
    tcptweaker
    fi
}        

delete_Tweaker() {
	clear
    mline2colour
    menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
    mline2colour
    echo
	read -p "Do you want to remove TCP Tweaker settings? [y/n]: " -e answer0
	if [[ "$answer0" = 'y' ]]; then
		grep -v "^#PH56
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null
		echo ""
		echo "TCP Tweaker network settings were successfully removed."
		echo ""
        read -n 1 -s -r -p "Press any key to back"
        tcptweaker
	else 
		echo ""
		tcptweaker
	fi
}    


install_Tweaker() {
	clear
    mline2colour
    menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
    mline2colour
    echo
	echo "Ini adalah skrip percubaan. Gunakan atas risiko anda sendiri!"
	echo "Skrip ini akan menukar beberapa network settings"
	echo "untuk mengurangkan latency dan meningkatkan kelajuan."
	echo ""
	read -p "Proceed with installation? [y/n]: " -e answer
	if [[ "$answer" = 'y' ]]; then
	echo ""
	echo "Modifying the following settings:"
	echo " " >> /etc/sysctl.conf
	echo "#PH56" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
echo ""
sysctl -p /etc/sysctl.conf > /dev/null
		echo "TCP Tweaker network settings have been added successfully."
		echo ""
        read -n 1 -s -r -p "Press any key to back"
        tcptweaker
	else
		echo ""
		echo "Installation was canceled by the user!"
		echo ""
	fi
}    

delete_Tweaker_2() {
	clear
    mline2colour
    menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
    mline2colour
    echo
	read -p "Do you want to remove TCP Tweaker settings? [y/n]: " -e answer0
	if [[ "$answer0" = 'y' ]]; then
		grep -v "^#GRPC
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_orphans = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384" /etc/sysctl.conf > /tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null
		echo ""
		echo "TCP Tweaker network settings were successfully removed."
		echo ""
        read -n 1 -s -r -p "Press any key to back"
        tcptweaker
	else 
		echo ""
		tcptweaker
	fi
}    


install_Tweaker_2() {
	clear
    mline2colour
    menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
    mline2colour
    echo
	echo "Ini adalah skrip percubaan. Gunakan atas risiko anda sendiri!"
	echo "Skrip ini akan menukar beberapa network settings"
	echo "untuk mengurangkan latency dan meningkatkan kelajuan."
	echo ""
	read -p "Proceed with installation? [y/n]: " -e answer
	if [[ "$answer" = 'y' ]]; then
	echo ""
	echo "Modifying the following settings:"
	echo " " >> /etc/sysctl.conf
	echo "#GRPC" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_orphans = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384" >> /etc/sysctl.conf
    echo ""
sysctl -p /etc/sysctl.conf > /dev/null
		echo "TCP Tweaker network settings have been added successfully."
		echo ""
        read -n 1 -s -r -p "Press any key to back"
        tcptweaker
	else
		echo ""
		echo "Installation was canceled by the user!"
		echo ""
	fi
}    

# menu tweaker
mline2colour
menucolour4 "${c7}       • MAGIC BBR & TCP Tweaker •         \e[0m"
mline2colour
tcp_status
bbr_status
menucolour4 "
 ${c6}[${c5}•1${c6}] Install BBR
 ${c6}[${c5}•2${c6}] Install TCP Tweaker
 ${c6}[${c5}•3${c6}] Delete BBR
 ${c6}[${c5}•4${c6}] Delete TCP Tweaker

 ${c6}[${c5}•0${c6}] \e[31mBACK TO MENU\033[0m"
mline2colour
echo -e "Type x atau [ Ctrl+C ] •Keluar-dari-Script"
echo -e ""
read -p "► Select menu :  "  opt
echo -e "$DF"
case $opt in
1) install_bbr 2>&1 ;;
2) install_Tweaker 2>&1 ;;
3) delete_bbr ;;
4) delete_Tweaker ;;
0) menu ;;
x) exit ;;
*) echo -e "" ; echo "Nombor Yang Anda Masukkan Salah!" ; sleep 2 ; menu ;;
esac