#Gets the server current date
    serverDate=$(curl -s 150.165.85.29:81/horaAtual | cut -d" " -f7)
    #serverDate=$(cat horaAtual | cut -d" " -f7)
    if [ $(cat menu.html | grep -c $serverDate) -gt 0 ] ;then
        #Gets server's current time
        serverHour=$(curl -s http://150.165.85.29:81/horaAtual |  cut -d' ' -f8)
        #Gets the hour that the commit should happen
        commitHour=$(cat menu.html | grep $serverDate | grep -o -m 1 [[:digit:]][[:digit:]]:[[:digit:]][[:digit:]])
        #Roteiro's Id of the day
        roteiroName=$(cat menu.html | grep -B1 -m 1 $serverDate | cut -d"-" -f6 | cut -d ">" -f2)
        #Gambi para que numeros como 08 nao sejam reconhecidos como octal
        serverSec=${serverHour:6:2}
        secUntilCommit=$(( (${commitHour:0:2} - ${serverHour:0:2}) * 3600 + (${commitHour:3:2} - ${serverHour:3:2}) * 60 + ${serverSec#0} ))
        #Time until the commit should begin
        timeUntillCommit=$(date -d@$secUntilCommit -u +%H:%M:%S)
        echo $timeUntillCommit

        echo $roteiroName
    else
        echo "No roteiro today :D";
    fi

    echo $serverDate
