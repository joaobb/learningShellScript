#Gets the server current date
    serverDate=$(curl -s 150.165.85.29:81/horaAtual | cut -d" " -f7)
    #serverDate=$(cat horaAtual | cut -d" " -f7)
    if [ $(cat menu.html | grep -c $serverDate) -gt 0 ] ;then
        #Gets the server current time
        serverHour=$(curl -s http://150.165.85.29:81/horaAtual |  cut -d' ' -f8)
        #Gets the hour that the commit should happen
        commitHour=$(cat menu.html | grep $serverDate | grep -o -m 1 [[:digit:]][[:digit:]]:[[:digit:]][[:digit:]])
        #Roteiro Id of the day
        roteiroName=$(cat menu.html | grep -B1 -m 1 $serverDate | cut -d"-" -f6 | cut -d ">" -f2)
        secTillComm=$((${serverHour:0:2} * 3600 + ${serverHour:3:2} * 60 + ${serverHour:6:2}))
        echo $serverHour
        echo $secTillComm
        echo $commitHour
        echo $roteiroName
    else
        echo "No roteiro today :D";
    fi

    echo $serverDate