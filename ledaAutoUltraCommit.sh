#!/bin/bash
#Author: joaobb

matricula=0;
roteiroName="";
turma=0;
gitUse=0;
secUntilCommit=0

function user() {
    userSubmit=1
    read -p "Do you want to use gitHub? [y/n]: " gitUse;
    if [ "$gitUse" != "${gitUse#[YySs1]}" ] ;then
        git config --global credential.helper store
        git pull
        gitUse=1;
    else gitUse=0
    fi

    if [ -e "lastRoteiro.data" ]; then                              #Verifies if it is the first time submitting for yourself
                                                            #Reads lastRoteiro.data data and assigns data to variables
        read -r matricula turma < lastRoteiro.data
    else                                                             #Gets alunos matricula, roteiroName and turma as input
       dataInput matricula, turma;
    fi
}

function getData() {
    #Gets leda's cronograma page
    cronograma=$(curl -s http://150.165.85.29:81/cronograma)
    #Gets leda's server time page
    serverTime=$(curl -s http://150.165.85.29:81/horaAtual)

    #Gets the server current date
    serverDate=$(echo $serverTime | grep -E -o [[:digit:]]{2}/[[:digit:]]{2}/[[:digit:]]{4})
    #serverDate=$(cat horaAtual | cut -d" " -f7)
    if [ $(echo $cronograma | grep -c $serverDate) -gt 0 ] ;then
        #Gets the server current time
        serverHour=$(echo $serverTime | grep -E -o [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2})
        #Gets the hour that the commit should happen
        commitHour=$(curl -s http://150.165.85.29:81/cronograma | grep $serverDate | grep -E -o -m 1 [[:digit:]]{2}:[[:digit:]]{2})
        #Roteiro's Id of the day
        roteiroName=$(curl -s http://150.165.85.29:81/cronograma| grep -B1 -m 1 $serverDate | cut -d"-" -f6 | cut -d ">" -f2)
        echo $roteiroName
        #Gambi para que numeros como 08 nao sejam reconhecidos como octal
        serverSec=${serverHour:6:2}
        secUntilCommit=$(( (${commitHour:0:2} - ${serverHour:0:2}) * 3600 + (${commitHour:3:2} - ${serverHour:3:2}) * 60 + ${serverSec#0} ))
    else
        echo "There is no LEDA class today ;D";
        exit 1
    fi
    echo $serverDate
}

function dataInput() {
    read -p "Matricula to be submitted: (XXXXXXXXX): " matricula;   #Gets for matricula
    read -p "Aluno's turma: (X) " turma;                            #Gets turma of aluno
	if [ $turma -gt 3 -o $turma -lt 1 -o $matricula -lt 100000000 -o $matricula -gt 999999999 ] ; then
		echo "Wrong input, please try again"
    bash ledaAutoUltraCommit.sh
	fi
}

function gitHubCommit() {
    echo "Commiting to gitHub ..."
    git add .
    git commit -m "Adição do "$roteiroName
    git push
}

#Here it starts

getData

read -p "Is this submit for you? [y/n]: " userSubmit;

case "$userSubmit" in                                              #Checks if roteiro will be submitted for the user or another matricula
["yY"] | ["sS"] | [1]) user matricula, turma;;               #Commit will be made with the data saved or will recieve it
[nN] | [0]) 		   dataInput matricula, turma;           #Commit will be made with a new input, and no aluno's data will be stored
            	       userSubmit=0;;
*) echo "Wrong input, please try again";                            #Wrong input
   exit 1;;
esac

LOADING=('|' '/' '--' '\')

while [ $secUntilCommit != -1 ];
    do
        sleep 1;                                                        #Sleeps for 1 sec
        clear;                                                          #Clear the terminal
        echo "Time until commit "$(date -d@$secUntilCommit -u +%H:%M:%S);
        echo ${LOADING[ $secUntilCommit % 4]}
        (( secUntilCommit-- ))
done

roteiroName=$roteiroName"-0"$turma

#This part was taken from gustavolbs's LEDA-AUTO-SEND repository
wget -O "$roteiroName.zip" --post-data="id=$roteiroName&matricula=$matricula" http://150.165.85.29:81/download
unzip  "$roteiroName.zip" -d $roteiroName
rm -rf "$roteiroName.zip"

sed -i "s/INSIRA SEU NUMERO DE MATRICULA/$matricula/g;s/R0X-0X/$roteiroName/g" $roteiroName/pom.xml
cd $roteiroName
mvn install -DskipTests

#</gustavo>

if [ -e $matricula"-send.log" ]; then                           #Success on submitting the roteiro
    if [ $userSubmit -eq 1 ]; then                              #Data will be stored
        cd ..
        echo $matricula $turma > lastRoteiro.data    #Storages the new roteiro id and your matricula
    fi
else
    echo "Something strange happened. Deleting this folder..."  #Something happaned and a log wasnt saved
    rm -rf $roteiroName                                  #It will delete the roteiro and quit the script
    exit 1;
fi

if [ $gitUse -eq 1 ]; then                                      #Commits the roteiro to gitHub
    gitHubCommit
fi

echo "Thank you for using this script :D"

exit 1;
