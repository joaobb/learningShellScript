#!/bin/bash
#Author: joaobb

matricula=0;
roteiroId=0;
turma=0;
gitUse=0;

function user() {
    userSubmit=1
    read -p "Do you want to use gitHub? [y/n]: " gitUse;
    if [ "$gitUse" != "${gitUse#[YySs1]}" ] ;then  
        git pull
        git config --global credential.helper store
        gitUse=1;

    else gitUse=0
    fi

    if [ -e "lastRoteiro.data" ]; then                              #Verifies if it is the first time submitting for yourself
                                                                    #Reads lastRoteiro.data data and assigns data to variables
        read -r matricula turma < lastRoteiro.data
    else                                                             #Gets alunos matricula, roteiroId and turma as input
       dataInput matricula, turma;
    fi
}

function getData() {
    #Gets the server current date
    serverDate=$(curl -s 150.165.85.29:81/horaAtual | cut -d" " -f7)
    #serverDate=$(cat horaAtual | cut -d" " -f7)
    if [ $(curl -s 150.165.85.29:81/cronograma | grep -c $serverDate) -gt 0 ] ;then
        #Gets the server current time
        serverHour=$(curl -s http://150.165.85.29:81/horaAtual |  cut -d' ' -f8)
        #Gets the hour that the commit should happen
        commitHour=$(curl -s 150.165.85.29:81/cronograma | grep $serverDate | grep -o -m 1 [[:digit:]][[:digit:]]:[[:digit:]][[:digit:]])
        #Roteiro Id of the day
        $roteiroName=$(curl -s 150.165.85.29:81/cronograma | grep -B1 -m 1 $serverDate | cut -d"-" -f6 | cut -d ">" -f2)
        secTillComm=${${commitHour:0:2} * 3600 + ${commitHour:2:2} * 60 + ${commitHour:4:2}}
        echo $commitHour
        echo $roteiroName
    else
        echo "No roteiro today :D";
    fi

    echo $serverDate
}

function dataInput() {
    read -p "Matricula to be submitted: (XXXXXXXXX): " matricula;   #Gets for matricula
    read -p "Aluno's turma: (X) " turma;                            #Gets turma of aluno
}

function gitHubCommit() {
    echo "Commiting to gitHub ..."
    git add .
    git commit -m "Adição de roteiro $roteiroName"
    git push
}

case $(date +%u) in                                                 #Day of the week 1...7 (1 == Monday)
1) classTime=16 ;;                                                  #Today == Monday -> ClassTime is 1600
4) classTime=14 ;;                                                  #Today == Thursday -> ClassTime is 1400
*) echo "There is no LEDA class today ;D";                          #No LEDA class today
   exit 1;;
esac                                            

read -p "Is this submit for you? [y/n]: " userSubmit;

case "$userSubmit" in                                               #Checks if roteiro will be submitted for the user or another matricula
["yY"] | ["sS"] | [1]) user matricula, roteiroId;;                  #Commit will be made with the data saved or will recieve it
[nN] | [0]) dataInput matricula, roteiroId;                         #Commit will be made with a new input, and no aluno's data will be stored
            userSubmit=0;;
*) echo "Wrong input, please try again";                            #Wrong input
   exit 1;;
esac

if [ $roteiroId -lt 10 ]; then                                      #Roteiro name adjusts
    roteiroName="R0"$roteiroId"-0$turma";
else roteiroName="R"$roteiroId"-0$turma";
fi

while
    sleep 1;                                                        #Sleeps for 1 sec
    clear;                                                          #Clear the terminal
    printf "Time until commit $(date -d@$(( ($(date -d 'today '$classTime':00:00' "+%s") - $(date "+%s")) )) -u +%T)\n";                 
    (( $(date +"%H") < $classTime ))                                #Verify if it is time to exit the loop
    do :; done

#This part was taken from gustavolbs's LEDA-AUTO-SEND repository
wget -O "$roteiroName.zip" --post-data="id=$roteiroName&matricula=$matricula" http://150.165.85.29:81/download
unzip  "$roteiroName.zip" -d $roteiroId"roteiro"
rm -rf "$roteiroName.zip"

sed -i "s/INSIRA SEU NUMERO DE MATRICULA/$matricula/g;s/R0X-0X/$roteiroName/g" $roteiroId"roteiro"/pom.xml
cd $roteiroId"roteiro"
mvn install -DskipTests

#</gustavo>

if [ -e $matricula"-send.log" ]; then                           #Success on submitting the roteiro
    if [ $userSubmit -eq 1 ]; then                              #Data will be stored
        cd ..
        ((roteiroId++))                                         #Sets roteiroId to the next one
        echo $roteiroId $matricula $turma > lastRoteiro.data    #Storages the new roteiro id and your matricula
    fi
else
    echo "Something strange happened. Deleting this folder..."  #Something happaned and a log wasnt saved
    rm -rf $roteiroId"roteiro"                                  #It will delete the roteiro and quit the script
    exit 1;
fi

if [ $gitUse -eq 1 ]; then                                      #Commits the roteiro to gitHub
    gitHubCommit
fi

echo "Thank you for using this script :D"

exit 1;
