#!/bin/bash

#Receaves all the input after the command
inp=$1

#Creates persistence files
touch toDoPers.dat donePers.dat

case $inp in
    #Saves the toDo message on a file
    -a*) echo - "${@:2}" >> toDoPers.dat;
        echo "== $(tail -1 toDoPers.dat) - has been successfully added to the list ==";;

         #Saves the file that will be deleted on another file.
    -d*) sed -n "$2p" toDoPers.dat >> donePers.dat;
         #Delete the chosen line
         sed -i "$2d" toDoPers.dat;
         echo "== $2 $(tail -1 donePers.dat) - has been successfully deleted from the list ==";;

         #Shows every ongoing tasks
    -sD) cat -n toDoPers.dat;;

         #Shows finished tasks
    -sF) cat -n donePers.dat;;

        #Shows every option that this lil "program" can handle
    -h) echo "-a [text] - Add a new thing to do";
        echo "-d [id]   - Complete the task with the given id";
        echo "-sT       - Show ongoing tasks";
        echo "-sD       - Show finished tasks"
        echo "-h        - Shows this shit :)";;

    *) echo "Try again later :D"
esac

#bye