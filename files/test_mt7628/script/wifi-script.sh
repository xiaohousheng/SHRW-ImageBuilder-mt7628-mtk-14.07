
#!/bin/sh

rm /tmp/wifi-scan-report

#Pubblico Il Report nella login ssh
#cat /etc/banner_base > /tmp/tmp_banner
#cat /tmp/banner_ssh_stats >> /tmp/tmp_banner
#cat /tmp/wifi-scan-report >> /tmp/tmp_banner
#cat /tmp/tmp_banner > /etc/banner
#rm /tmp/tmp_banner

country=$(uci show wireless.radio0.country | sed -e 's,wireless.radio0.country=\([^<]*\),\1,g' | cut -d "'" -f 2)
if [ $country = "IT" ] ; then
#	echo "UAOO"
	echo "Country IT - Uso 13 Canali"
	sh /script/ludo/wifi-script-13.sh
else
#	echo "Fucking USA"
	echo "Country US - Uso 11 Canali"
	sh /script/ludo11/wifi-script-11.sh
fi

exit 0

