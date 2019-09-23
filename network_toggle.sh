#!/bin/bash


ip_server=http://www.baidu.com
ip_server=http://www.mi.com
ip_server=10.18.103.150
#ip_server=172.31.255.254
dev_phy=wlxec3dfdfa4cbb
latency_ok=4000
signal_intensity_ok=70
w_signal_intensity=1
w_latency=2
wifi_quality_ok=70

for i in $(seq 1 200) 
do
    sleep 3;

    httping -c1 -g $ip_server >/home/denny/test/latency.txt


    iw dev $dev_phy link > /home/denny/test/link_info.txt
    #sig_intensity='grep "signal*" link_info.txt'

    sig_intensity=$(cat link_info.txt | grep "sign*"|cut -c11-12);
    bssid=$(cat link_info.txt | grep "Connected*"|cut -c14-31);
    latency=$(cat latency.txt | grep "connected*"|cut -c56-57);

  #  wifi_quality_1=$(($w_signal_intensity*$sig_intensity))
  #  wifi_quality_2=$(($w_latency*$latency))
   # wifi_quality=$(($wifi_quality_1+$wifi_quality_2))

    #echo "wifi quality is " $wifi_quality

    #if the signal is null or the lantecy is timeout then reconnect immediately
    if [ ! $sig_intensity ];then
        echo "network is not connected " "    reconnecting...";
        sudo iw dev $dev_phy disconnect;
        sleep 12;
    else if [ ! $latency ];then
        echo "network is  very bad  time out " "    reconnecting...";
        sudo iw dev $dev_phy disconnect;
        sleep 12    ;
        
    else if [ $latency -gt $latency_ok ];then
        echo "network is  very bad  latency too long" "    reconnecting...";
        sudo iw dev $dev_phy disconnect;
        sleep 12    ;
               
    else if [ $sig_intensity -lt $signal_intensity_ok ]; then
        echo "BSSID is " $bssid"  signal intensity is " $sig_intensity  "  latency is " $latency  "   network is ok";
    else
        echo "BSSID is " $bssid"   signal intensity is " $sig_intensity "  latency is " $latency"   network is bad";
        echo "reconnecting";
        sudo iw dev $dev_phy disconnect;
        sleep 12;
        
     
    fi
    fi
    fi
    fi
done
