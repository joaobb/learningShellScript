#Small script to get LEDA's server time
curl -s http://150.165.85.29:81/horaAtual | cut -d' ' -f8