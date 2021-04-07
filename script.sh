#!/usr/bin/env bash
#trap exiting EXIT
#trap "" SIGINT

exiting () {
        echo "exiting"
	pkill -KILL -u test
}

menu () {
        echo "Please select an option:"
        echo "1. Network Setting from CLI."
        echo "2. Change network Setting"
        echo "3. Restart network"
        echo "4. Change Date and Time"
        echo "5. Shutdowm"
        echo "6. Reboot"
        echo "7. Logout "
read option

}

menu

furtheraction () {
        echo "Do you want to perform any other task: "
        echo "1: Yes "
        echo "2. Exit"
        read xy
        if [[ $xy -eq 1 ]]
        then
                clear
		menu
        elif [[ $xy -eq 2 ]]
        then
                exit
        else
                clear
		echo "You Entered and invalid Option"
                menu
	fi
}

networkconf () {
# Creates a backup
sudo cp /etc/netplan/test-50-cloud-init.yaml.bk /etc/netplan/test-50-cloud-init.yaml.bk_`date +%Y%m%d%H%M`

# Changes dhcp from 'yes' to 'no'
#sudo sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/test-50-cloud-init.yaml.bk

#nic=`ifconfig | awk 'NR==1{print $1}'`
nic=`sudo lshw -class network | grep "logical name: *" | cut -d ":" -f2`

# Ask for input on network configuration
read -p "Enter the static IP of the server in CIDR notation: " staticip
read -p "Enter the IP of your gateway: " gatewayip
read -p "Enter the IP of preferred nameservers (seperated by a coma if more than one): " nameserversip
echo
sudo cat > /etc/netplan/test-50-cloud-init.yaml.bk <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
   $nic
      dhcp4: false
      addresses:
        - $staticip
      gateway4: $gatewayip
      nameservers:
        addresses: [$nameserversip]
      set-name:$nic

EOF
#sudo netplan apply
echo "==========================="
}

ChngDateTime () {
        echo "Enter Date and Time in Following format"
        echo "DD MM YY"
        read dateinput
        echo "HH:MM:SS"
        read timeinput
        sudo date --set "$dateinput $timeinput"
}

while true
do
        if [[ $option -ge 1 && $option -le 7 ]]
        then
                x=$option
                
                if [ $x -eq 1 ]
                then
                       echo "Your Selected number is: $x"
                        ip addr
			furtheraction
                elif [ $x -eq 2 ]
                then
                       echo "Your Selected number is: $x"
		       furtheraction
                elif [ $x -eq 3 ]
                then
                       echo "Your Selected number is: $x"
                      # sudo netplan apply
		      futheraction
                elif [ $x -eq 4 ]
                then
                       echo "Your Selected number is: $x"
		       ChngDateTime
                       furtheraction
                elif [ $x -eq 5 ]
                then
                       echo "Your Selected number is: $x"
		       echo "Powering off"
                      sudo poweroff
	       elif [ $x -eq 6 ]
                then
                       echo "Your Selected number is: $x"
		       echo "Restarting"
		       sudo reboot
                elif [ $x -eq 7 ]
                then
                        echo "logging out...."
                        exit
                fi
        else
                echo "Please enter a valid number"
                menu
        fi

done
