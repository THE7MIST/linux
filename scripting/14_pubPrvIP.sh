#!/bin/bash
#Check user input ip is public private or apipa
#calss A private ip range 10.0.0.0-10.255.255.255
#class B private ip range 172.16.0.0-172.32.255.255
#calss C private ip range 192.168.0.0-192.168.255.255
#APIPA ip address 169.254.0.0-169.255.255
#lookback ip 127.0.0.0-127.255.255.255

valid=1

#take ip from user separated by "." and oct1 oct2 oct3 and oct4
IFS="." read -rp "Enter IP add.: " o1 o2 o3 o4 extra

#now check ip is valid or not?
echo "Check enterd ip is valid or not?:"

[[ -n $o4 && -z $extra ]] || valid=0

for oct in $o1 $o2 $o3 $o4; do
        [[ $oct =~ ^[0-9]{1,3}$ && $oct -le 255 ]] || valid=0
done

(( valid )) && echo "$o1.$o2.$o3.$o4 is valid IP" || echo "Invalid IP "

if [[ $valid -eq 1 ]]; then
        if [[ $o1 -eq 10 ]]; then
                echo "private ip of class A"
        elif [[ $o1 -eq 172 && $o2 -ge 16 && $o2 -le 32 ]]; then
                echo "private ip of class B"
        elif [[ $o1 -eq 192 && $o2 -ge 168 ]]; then
                echo "privaye ip of class C"
        elif [[ $o1 -eq 169 && $o2 -ge 254 ]]; then
                echo "APIPA"
        elif [[ $o1 -eq 127 ]]; then
                echo "lookback"
        else
               echo "public ip"
        fi
else
        echo "invalid ip"
fi                                                                                                                                                                                                     
                                                                                                                                                                                                                                         
~                                                                                                                                                                                                                                            
~                      
