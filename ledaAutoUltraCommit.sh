#!/bin/bash
#Author: joaobb

#Variables
weekDay=$(date +%u);                            #Day of the week 1...7 (1 == Monday)

if [ -e "lastRoteiro.data" ];                   #Verifies if lastRoteiro.data exists
    then                                        #Reads lastRoteiro.data data and assigns to variables
    read -r roteiroId matricula < lastRoteiro.data
else                                            #Receaves last roteiroId and students matricula
    read -p "Last roteiro digit (RXX-01): " roteiroId;
    read -p "Your matricula (XXXXXXXXX): " matricula;
fi
#/Variables

if [ $weekDay -eq 1 ];                          #Today == Monday
    then classTime=16 ;                         #Class time is 1600
elif [ $weekDay -eq 4 ];                        #Today == Wednesday
    then classTime=14 ;                         #Class time is 1400
else                                            #No LEDA class today
    echo "There is no LEDA class today ;D";
    exit 1;    
fi;

((roteiroId++))                                 #Sets to a new roteiro
if [ $roteiroId -lt 10 ];                       #String formatation
    then roteiroName="R0"$roteiroId"-01";       #09
else roteiroName="R"$roteiroId"-01";            #10
fi

echo $roteiroId $matricula > lastRoteiro.data   #Storages the new roteiro id and your matricula

while
    currentHour=$(date +"%H");                  #Updates system hour
    currentTime=$(date +"%T");                  #Updates system time
    sleep 1;                                    #Sleeps for 1 sec
    clear;                                      #Clear the terminal
    printf "\b\b$currentTime";
    (( $currentHour < $classTime ))             #Verify if it is time to exit the loop
    do :; done

#This part was taken from gustavolbs's LEDA-AUTO-SEND repository
wget -O "$roteiroName.zip" --post-data="id=$roteiroName&matricula=$matricula" http://150.165.85.29:81/download
unzip  "$roteiroName.zip" -d "$roteiroName"
rm -rf "$roteiroName.zip"

sed -i "s/INSIRA SEU NUMERO DE MATRICULA/$matricula/g;s/R0X-0X/$roteiroName/g" "$roteiroName"/pom.xml 
cd $roteiroName
mvn install -DskipTests