#!/bin/bash
#Author: joaobb

#Variables
weekDay=$(date +%u);                     #Day of the week 1...7 (1 == Monday)

if [ -e "lastRoteiro.data" ];
    then read input < lastRoteiro.data  #Reads the file to get the last roteiro sent
else
    read -p "Last roteiro digit (RXX-01): " input;
fi

matricula='117210327';                  #Student ID
#/Variables

if [ $weekDay -eq 1 ];                  #Today == Monday
    then classTime=16 ;                 #Class time is 1600
    ((input++))                         #Sets to a new roteiro
elif [ $weekDay -eq 4 ];                #Today == Wednesday
    then classTime=14 ;                 #Class time is 1400
    ((input++))                         #Sets to a new roteiro
else                                    #No LEDA class today
    echo "There is no LEDA class today ;D";
    exit 1;    
fi;


if [ $input -lt 10 ];                   #String formatation
    then roteiroName="R0"$input"-01";   #09
else roteiroName="R"$input"-01";        #10
fi
echo $input > lastRoteiro.data          #Saves current roteiros number

while
    currentHour=$(date +"%H");          #Updates system hour
    currentTime=$(date +"%T");          #Updates system time
    sleep 1;                            #Sleeps for 1 sec
    clear;                              #Clear the terminal
    printf "\b\b$currentTime";
    (( $currentHour < $classTime ))     #Verify if it is time to exit the loop
    do :; done

#This part was taken from gustavolbs's LEDA-AUTO-SEND repository
wget -O "$roteiroName.zip" --post-data="id=$roteiroName&matricula=$matricula" http://150.165.85.29:81/download
unzip  "$roteiroName.zip" -d "$roteiroName"
rm -rf "$roteiroName.zip"

sed -i "s/INSIRA SEU NUMERO DE MATRICULA/$matricula/g;s/R0X-0X/$roteiroName/g" "$roteiroName"/pom.xml 
cd $roteiroName
mvn install -DskipTests