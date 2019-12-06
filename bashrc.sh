function op() {
    if [ "$1" == "" ] ;then
	xdg-open ./ >/dev/null 2>&1 
    else
	xdg-open "$1" >/dev/null 2>&1 
    fi
}

alias pls="sudo"

function extr() {
    ls -d */ | awk '{ system("cd \""$0"\" && mv *.mp4 ../ && cd ../ ") }'
}