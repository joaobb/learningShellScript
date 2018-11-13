wget http://150.165.85.29:81/horaAtual

egrep "([0-9]{2}):([0-9]{2}):([0-9]{2})" horaAtual

echo $1