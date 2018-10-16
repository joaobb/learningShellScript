#!/bin/bash
#Author: joaobb

read -p "Do you want to commit it to gitHub? [y/n] -> " gitUse;

if [ "$gitUse" != "${gitUse#[YySs1]}" ] ;       #Checks if the user wants to use gitHub
then 
    gitUse=1                                    #gitHub will be used
    git config credential.helper store          #Storages users github info
    git pull                                    #Pulls your LEDA repository
else gitUse=0
fi

weekDay=$(date +%u);                            #Day of the week 1...7 (1 == Monday)

if [ -e "lastRoteiro.data" ];                   #Verifies if lastRoteiro.data exists
    then                                        #Reads lastRoteiro.data data and assigns to variables
    read -r roteiroId matricula < lastRoteiro.data
else                                            #Receives last roteiroId and students matricula / First time using this script
    read -p "Last roteiro digit (RXX-01): " roteiroId;
    read -p "Your matricula (XXXXXXXXX): " matricula;
fi

case $(date +%u) in                             #Day of the week 1...7 (1 == Monday)
1) classTime=16 ;;                              #Today is Monday - Class time is 1600
4) classTime=14 ;;                              #Today is Wednesday - Class time is 1400
*) echo "There is no LEDA class today ;D";      #No LEDA class today
   exit 1;
esac

((roteiroId++))                                 #Sets to a new roteiro

if [ $roteiroId -lt 10 ];                       #String formatation
    then roteiroName="R0"$roteiroId"-01";       #01 <roteiro <= 09
else roteiroName="R"$roteiroId"-01";            #roteiro <= 10
fi

while
    sleep 1;                                    #Sleeps for 1 sec
    clear;                                      #Clear the terminal
    printf "\b\b$(date +"%T")";
    (( $(date +"%H") < $classTime ))            #Verify if it is time to exit the loop
    do :; done

#This part was taken from gustavolbs's LEDA-AUTO-SEND repository and edited by joseTheDev
wget -O "$roteiroName.zip" --post-data="id=$roteiroName&matricula=$matricula" http://150.165.85.29:81/download
unzip  "$roteiroName.zip" -d $roteiroId"roteiro"#Unzip the roteiro to a folder named Xroteiro
rm -rf "$roteiroName.zip"

sed -i "s/INSIRA SEU NUMERO DE MATRICULA/$matricula/g;s/R0X-0X/$roteiroName/g" $roteiroId"roteiro"/pom.xml 
cd $roteiroId"roteiro"
mvn install -DskipTests

if [ ! -e $matricula"-send.log" ];              #Checks if maven saved a log, if so, everything gone right.
    then echo "Something strange happened";     #Something strange happened, and the script will end without
    exit 1;                                     #updating the user data and its repository
fi

echo $roteiroId $matricula > lastRoteiro.data   #Storages the new roteiro id and your matricula

echo "Time spent: "$(date +"%M:%S")             #Prints the time to conclude the submit

if [ $gitUse -eq 1] ; 
then                                            #Commits the changes to your github repository master branch
    git add .
    git commit -m "Adição de roteiro" $roteiroId #Commit message follows the "Adição de roteiro X" pattern
    git push origin master
fi

echo "Thank you for using this thing"