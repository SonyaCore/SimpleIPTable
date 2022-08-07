#!/bin/bash

# IPTABLE Service (IPTableConf)
# --------------------------------
# author    : SonyaCore
#	      https://github.com/SonyaCore
#

# Main Var :
SSHPORT=22
FTPPORT=20:21
WEBSERVER=80
ROOT_UID=0

#Permission
permissioncheck(){
if [[ $UID == $ROOT_UID ]]; then true ; else echo -e "You Must be the ROOT to Perfom this Task" ; exit 1 ; fi
}


help(){
            printf "$(tput setaf 2)IP Table \nexample: sudo iptables.sh -b -a 5000 -a 443 $(tput sgr0)"
            echo ""
            echo "َUsage:"
            echo ""
            echo "Policy:"
            echo "[-default | --defaultiptable]    Add Default ports Without Blocking all policy"
            echo "[-b | --blockall ]               Block All Policy and add Default Ports"
            echo "[-f | --flushall ]               Flush All Polciy and set All Policy to ACCEPT"
            echo ""
            echo "[-finput | --flushinputchain]    Flush INPUT Chain"
            echo "[-foutput | --flushoutputchain]  Flush OUTPUT Chain"
            echo ""
            echo "Filter:"
            echo "[-a | --accept]                  Add Port with ACCEPT target"
            echo "[-d | --delaccept]               Delete Port with ACCEPT target"
            echo ""
            echo "[-afilter | --addportfilter]     Add Port With DROP target"
            echo "[-dfilter | --delportfilter]     Delete Port With DROP target"
            echo ""
            echo "[-s | --save]                    Save Rules for Restoring on Startup"
}

permissioncheck

#Parse Argument
args=( )

iptables_default(){
   #SSH
    iptables -t filter -A INPUT -p tcp --dport $SSHPORT -j ACCEPT
    iptables -t filter -A OUTPUT -p tcp --dport $SSHPORT -j ACCEPT
   ##HTTP
    iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT 
   #NTP
    iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
   #FTP
    iptables -t filter -A INPUT -p tcp --dport $FTPPORT -j ACCEPT 
    iptables -t filter -A OUTPUT -p tcp --dport $FTPPORT -j ACCEPT 
   #MYSQL
    iptables -t filter -A INPUT -p tcp --dport 3306 -j ACCEPT
    iptables -t filter -A OUTPUT -p tcp --dport 3306 -j ACCEPT
   #DNS
    iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
    iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
    iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
   #PING
    iptables -t filter -A INPUT -p icmp -j ACCEPT
    iptables -t filter -A OUTPUT -p icmp -j ACCEPT

}

iptables_addportfilter(){
    iptables -t filter -A INPUT -p tcp --dport $PORT -j DROP
    iptables -t filter -A OUTPUT -p tcp --dport $PORT -j DROP

}

iptables_delportfilter(){
    iptables -t filter -D INPUT -p tcp --dport $PORT -j DROP
    iptables -t filter -D OUTPUT -p tcp --dport $PORT -j DROP

}

iptables_addportaccept(){
   iptables -t filter -A INPUT -p tcp --dport $PORT -j ACCEPT
   iptables -t filter -A OUTPUT -p tcp --dport $PORT -j ACCEPT
}

iptables_delportaccept(){
      iptables -t filter -D INPUT -p tcp --dport $PORT -j ACCEPT
      iptables -t filter -D OUTPUT -p tcp --dport $PORT -j ACCEPT
}

iptables_blockall(){
    iptables -t filter -P INPUT DROP
    iptables -t filter -P OUTPUT DROP
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -t filter -A INPUT -i lo -j ACCEPT
    iptables -t filter -A OUTPUT -o lo -j ACCEPT
    iptables_default
}

flushinputchain(){
    iptables -F INPUT
}

flushoutputchain(){
    iptables -F OUTPUT
}

flushall(){
    iptables -F
    iptables -t filter -X

   setactive(){
    iptables -t filter -P INPUT ACCEPT
    iptables -t filter -P FORWARD ACCEPT
    iptables -t filter -P OUTPUT ACCEPT
   }
   setactive
}

saverule(){
    iptables-save > /etc/rule.fw
   if [[ "$(cat /etc/rc.local)" =~ .*iptables-restore.* ]]; then true ; else echo "/sbin/iptables-restore < /etc/rule.fw" | tee -a /etc/rc.local ; fi
}

while (( $# )); do
   case $1 in
      -h | --help) help ; exit 1 ;;
      -afilter | --addportfilter) PORT=$2 ; iptables_addportfilter ;;
      -dfilter | --delportfilter) PORT=$2 ; iptables_delportfilter ;;
      -a | --accept ) PORT=$2 ; iptables_addportaccept ;;
      -d | --delaccept ) PORT=$2 ; iptables_delportaccept  ;;
      -finput |--flushinputchain ) flushinputchain ;;
      -foutput |--flushoutputchain ) flushoutputchain ;;
      -f | --flushall ) flushall ;;
      -b | --blockall ) iptables_blockall ;;
      --default ) iptables_default ;; #Add ports Without Blocking all policy
      -s | --save ) saverule ;;
      -*) echo "Error: Invalid option" >&2; exit 1 ;;
   esac
   shift
done

# Add Parsed Argument to args
set -- "${args[@]}"

: <<'CHAIN'
Chain Port for file:
for x in `cat table` ;  do sudo iptables -t filter -A INPUT -p tcp --dport $x -j ACCEPT ; done

Chain Port with dumped sql data :
mysql -B --column-names=0 -uroot -p123 --database DBNAME -e "SELECT PORT FROM PortFiltering;" > iptable
for ips in `cat iptable` ;  do sudo iptables -t filter -A INPUT -p tcp --dport $ips -j ACCEPT ; done
rm -rf iptable
CHAIN