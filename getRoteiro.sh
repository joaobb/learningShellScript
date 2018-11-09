#Get roteiros names without turma, that will be inserted by the aluno
grep "title='Aula " cronograma.html | cut -d'>' -f2 | cut -d'-' -f1

name="<td class="text-xs-center" data-toggle="tooltip" data-placement="right" title='Atividade inicia em 03/09/2018 16:00'>03/09"
strin=${"<td class="text-xs-center" data-toggle="tooltip" data-placement="right" title='Atividade inicia em 03/09/2018 16:00'>03/09"##*em }
echo "$strin" | cut -d"'" -f1