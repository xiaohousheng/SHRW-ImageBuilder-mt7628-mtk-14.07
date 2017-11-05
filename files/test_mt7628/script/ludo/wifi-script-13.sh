
#!/bin/sh

#mi sposto nella cartella di lavoro
cd /script/ludo/

#eseguo la scansione
iwinfo wlan0 scan > scan.tmp

#estrapolo dati importanti
cat scan.tmp | awk /ESSID/'{print $2$3$4;}' > essid.tmp  
cat scan.tmp | awk /Address/'{print $5;}' > mac.tmp 
cat scan.tmp | awk /Channel/'{print $4;}' > ch.tmp
cat scan.tmp | awk /Signal/'{print $2;}'  > signal.tmp
iw dev wlan0 survey dump |awk /noise/'{print $2}' > noise.tmp
iw dev wlan0 survey dump |awk /frequency/'{print $2}' > freq.tmp

rm scan.tmp

#copio tutte le informazioni in un file per colonna (tipo comando paste)
awk -f paste.awk essid.tmp mac.tmp ch.tmp signal.tmp > wifiscan.dat 

rm essid.tmp mac.tmp ch.tmp signal.tmp
#stampo risultati
echo "----------------Scansione----------------------"
echo "----------------Scansione----------------------" >> /tmp/wifi-scan-report
cat wifiscan.dat
cat wifiscan.dat >> /tmp/wifi-scan-report

#creo un file in cui genero le statistiche
awk -f stat.awk wifiscan.dat noise.tmp freq.tmp > stat.dat 

rm wifiscan.dat noise.tmp freq.tmp

echo "----------------Statistiche--------------------"
echo "----------------Statistiche--------------------" >> /tmp/wifi-scan-report
echo "ch numap lowlvl weight l r l2 r2 noise freq"
echo "ch numap lowlvl weight l r l2 r2 noise freq" >> /tmp/wifi-scan-report
cat stat.dat
cat stat.dat >> /tmp/wifi-scan-report

echo "---------------Canale migliore-----------------"
echo "---------------Canale migliore-----------------" >> /tmp/wifi-scan-report

#eseguo l'ultimo script che mi crea il file con il canale migliore e la sua relativa frequenza
awk -f final.awk stat.dat > bestch.dat

rm stat.dat

cat bestch.dat
cat bestch.dat >> /tmp/wifi-scan-report

data=$(date)

#se il file bestch esiste
if [ -f "bestch.dat" ]
then
	uaone=$(wc -l bestch.dat | awk '{print $1}' )
	if [ "$uaone" -eq 1 ]
	then
		ch=$(cat bestch.dat | awk '{print $1}' )
		freq=$(cat bestch.dat | awk '{print $2}' )
		chcurrent=$(iwinfo wlan0 info | awk /Channel/'{print $4}')
		
		if [ "$ch" != "$chcurrent" ]
		then		
			if [ "$ch" -eq 1 ] || [ "$ch" -eq 11 ]
			then
				txpower=19
			else
				txpower=21
			fi

			#uci set wireless.radio0.txpower=$txpower
			uci set wireless.radio0.channel=$ch
			uci commit
			#wifi

		 	hostapd_cli chan_switch $ch $freq
		
			#stampo log
			echo "In data: " $data " Canale: " $ch " - Frequenza: " $freq #>> bestch.log
			echo "In data: " $data " Canale: " $ch " - Frequenza: " $freq >> /tmp/wifi-scan-report
		else
			ch=-1
			echo "Canale identico a prima!"
			echo "Canale identico a prima!" >> /tmp/wifi-scan-report
		fi
	fi
fi

if [ -z "$ch" ]
then
	#Se sono nella condizione di errore
	if [ -f "bestch.dat" ]
	then
		echo "In data: " $data " - Errore: ho più di un canale nel file bestch!" #>> bestch.log	
		echo "In data: " $data " - Errore: ho più di un canale nel file bestch!" >> /tmp/wifi-scan-report
	else
		echo "In data: " $data " - Errore: non trovo il file del canale migliore!" #>> bestch.log
		echo "In data: " $data " - Errore: non trovo il file del canale migliore!" >> /tmp/wifi-scan-report
	fi
fi

rm bestch.dat

#Pubblico Il Report nella login ssh
cat /etc/banner_base > /tmp/tmp_banner
cat /tmp/banner_ssh_stats >> /tmp/tmp_banner
cat /tmp/wifi-scan-report >> /tmp/tmp_banner
cat /tmp/tmp_banner > /etc/banner
rm /tmp/tmp_banner


