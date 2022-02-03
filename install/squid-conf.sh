#!/bin/bash
# check izin
CEKIZIN () {
    IZIN=$(curl -sS https://raw.githubusercontent.com/cloudiomy/access-ip/main/access-ip | awk '{print $4}' | grep $MYIP3)
    if [[ "${MYIP3}" == "${IZIN}" ]]; then
	clear
    echo -e "[ OK ] Access authorized"
    else
    clear
    echo -e "[ ERROR ] Access is denied"
    echo -e "[ Info ] Please Contact Admin  # NAK DAFTAR IP ? CONTACT SAYA @cloudio_admin DI TELEGRAM"
    exit 0
    fi

}

CEKIZIN
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
visible_hostname cloudiomy" > /etc/squid/squid.conf

echo -e "[ Info ] Restart squid service"
sleep 2
/etc/init.d/squid restart
echo -e "[ Info ] Pemasangan squid config telah selesai"
sleep 2
