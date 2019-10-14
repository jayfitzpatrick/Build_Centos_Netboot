#!/bin/sh
clear
cd_major="7.7"
cd_minor="1908"
read -e -p "Enter IP or Hostname of ESXi host:"  esxi_host
read -e -p "Enter Datastore:"  esxi_datastore
read -e -p "Enter ESXi Username:"  esxi_username
read -s -e -p "Enter the password for ${esxi_username} (this will not be printed to the screen:"  esxi_password
printf "\n"
read -e -p "Enter SSH Username (press enter for root): " -i "root" ssh_username
read -s -e -p "Enter the password for ${ssh_username} (this will not be printed to the screen:"  ssh_password
printf "\n"

options=("sha256" "sha1" "other")

echo "Select a Checksum Type"
PS3="Pick an option "
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    1 ) iso_checksum_type="$opt";echo "Setting Checksum to $iso_checksum_type";break;;
    2 ) iso_checksum_type="$opt";echo "Setting Checksum to $iso_checksum_type";break;;
    3 ) echo "You picked $opt please type your prefered Checksum";read iso_checksum_type;echo "Setting Checksum to $iso_checksum_type";break;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac
done

options=("http://ftp.heanet.ie" "http://mirror.strencom.net" "other")

echo "Select a Download Location"
PS3="Pick an option "
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    1 ) iso_url="http://ftp.heanet.ie/pub/centos/${cd_major}.${cd_minor}/isos/x86_64/CentOS-7-x86_64-Minimal-${cd_minor}.iso";echo "Setting ISO Download location to ${iso_url}";break;;
    2 ) iso_url="http://mirror.strencom.net/centos/${cd_major}.${cd_minor}/isos/x86_64/CentOS-7-x86_64-Minimal-${cd_minor}.iso";echo "Setting ISO Download location to ${iso_url}";break;;
    3 ) echo "You picked $opt please paste your prefered ISO Download location";read iso_url;echo "Setting ISO Download location to ${iso_url}";break;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac
done

if [[ ! -e ./CentOS-7-x86_64-Minimal-${cd_minor}.iso ]]; then
wget ${iso_url} -O ./CentOS-7-x86_64-Minimal-${cd_minor}.iso
fi


checksum_dl=`echo ${iso_url}|sed 's/\(.*\)[/].*/\1/'`
if [ "${iso_checksum_type}" = sha256 ] ; then
iso_checksum=`curl -s ${checksum_dl}/sha256sum.txt |grep CentOS-7-x86_64-Minimal-${cd_minor}.iso|awk '{print $1}'`
echo "${iso_checksum} ./CentOS-7-x86_64-Minimal-${cd_minor}.iso" |sha256sum -c -
else
iso_checksum=`curl -s ${checksum_dl}/sha1sum.txt  |grep CentOS-7-x86_64-Minimal-${cd_minor}.iso|awk '{print $1}'`
echo "${iso_checksum} ./CentOS-7-x86_64-Minimal-${cd_minor}.iso" |sha1sum -c -
fi
#echo "The ${iso_checksum_type} is ${iso_checksum}"
