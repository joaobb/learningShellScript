#Gets the server current date
serverDate=$(curl -s 150.165.85.29:81/horaAtual | cut -d" " -f7)
#serverDate=$(cat horaAtual | cut -d" " -f7)
if [ $(curl -s 150.165.85.29:81/cronograma | grep -c $serverDate) -gt 0 ] ;then
    #Gets the server current time
    serverHour=$(curl -s http://150.165.85.29:81/horaAtual |  cut -d' ' -f8)
    #Gets the hour that the commit should happen
    commitHour=$(curl -s 150.165.85.29:81/cronograma | grep $serverDate | grep -o -m 1 [[:digit:]][[:digit:]]:[[:digit:]][[:digit:]])
    #Roteiro Id of the day
    roteiroId=$(curl -s 150.165.85.29:81/cronograma | grep -B1 -m 1 $serverDate | cut -d"-" -f6 | cut -d ">" -f2)
    echo $commitHour
    echo $roteiroId
else
    echo "No roteiro today :D";
fi

echo $serverDate