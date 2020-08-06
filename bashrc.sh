# -- General --
alias pls="sudo"
alias grep="grep --color"
alias stts="systemctl status"

# -- Docker --
alias dc="docker-compose"

# -- Git --
alias gitb="git branch"
alias gitch="git checkout"
alias gitco="git commit -m"
alias gti="git"
alias giff="git diff"
alias gits="git status"
alias gitnp="git push --set-upstream origin $(git_current_branch)"

# FUNctions

nolog() {
    	$* > /dev/null 2>&1 &
}

op() {
    if [[ $1 == "" ]] 
    then
	xdg-open ./ >/dev/null 2>&1 
    else
	xdg-open "$1" >/dev/null 2>&1 
    fi
}

# Create dir if there isnt one, and goes into it.
xd() {
    if ! [[ -d "$1" ]]
    then
	mkdir $1
	cd $1
    else
	cd $1
    fi
}

function extr() {
    ls -d */ | awk '{ system("cd \""$0"\" && mv *.mp4 ../ && cd ../ ") }'
}

function start() {
    if [[ -f "yarn.lock" ]];
    then 
	    echo Starting YARN server 
	    sudo yarn start
    else 
	    echo Starting NPM server
	    sudo npm start
fi
}

function gitnb() {
    echo '(F)eature'
    echo '(E)nhancement'
    echo '(B)ugfix'

    vared -p "Branch type: " -c branchType;

    vared -p "Issue number: " -c issueNumber;

    case "$branchType" in
	    ["fF"]) git checkout -B "ISSUE${issueNumber}-FEATURE";;
	    ["eE"]) git checkout -B "ISSUE${issueNumber}-ENHANCEMENT";;
	    ["bB"]) git checkout -B "ISSUE${issueNumber}-BUGFIX";;
		 *) echo "Wrong branch type, fella, try again! :D";;
 esac	
}
