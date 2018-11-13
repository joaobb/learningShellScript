read -p "Put the video post link here: " postUrl;
mobUrl=$(echo $postUrl | sed 's/www/m/')
videoUrl=$(curl $mobUrl | grep -o '<meta property="og:video" content=.*/>' | cut -d'"' -f4 | sed 's/\&amp;/\&/g')
wget -O video.mp4 "$videoUrl"

# | sed 's/\(<meta property="og:video" content=\| \/>\)//g' 
# | sed 's/\&amp/\&/g'
# sed -i 's/&//&'/

# sed -e 's/<Currentnumber>\(.*\)<\/Currentnumber>/\1/' file.html
# sed -e 's/<meta property="og:video" content="\(.*\)\/>/\1/' fbVideo.html
# s= egrep '<meta property="og:video" content="(.*)/>' fbVideo.html

# sed -n '/<meta property="og:video" content=[^>]*//>' fbVideo.html

# tag='<meta property="og:video" content='
# sed '/<meta property="og:video" content=\(,\)\/>/p' fbVideo.html

# rg -o '/<meta property="og:video" content=(\w+)' -r '$1'

# tag='<meta property="og:video" content='
# grep -o '<meta property="og:video" content=.* />' fbVideo.html | wget sed 's/\(<meta property="og:video" content=\|\/>\)//g'

# https://video.fjpa1-1.fna.fbcdn.net/v/t42.9040-2/45447886_355940678491758_4887921757807181824_n.mp4?_nc_cat=110&efg=eyJ2ZW5jb2RlX3RhZyI6InN2ZV9zZCJ9&_nc_ht=video.fjpa1-1.fna&oh=5884d6812cc9799247f2a5376a8e6b66&oe=5BE63BE4
# https://video.ffor3-1.fna.fbcdn.net/v/t42.9040-2/45447886_355940678491758_4887921757807181824_n.mp4?_nc_cat=1&efg=eyJ2ZW5jb2RlX3RhZyI6InN2ZV9zZCJ9&_nc_ht=video.ffor3-1.fna&oh=74e6a8e4a040ade9d5a5972702d3b2b5&oe=5BE5D974
# https://m.facebook.com/story.php?story_fbid=445506072643884&id=201490800316184&_rdr
# https://video.fcpv4-1.fna.fbcdn.net/v/t42.9040-2/44287616_2023019517741959_4609156222560501760_n.mp4?_nc_cat=101&efg=eyJ2ZW5jb2RlX3RhZyI6InN2ZV9zZCJ9&_nc_ht=video.fcpv4-1.fna&oh=ab9e2c52a93d9663273dc2e9ac29913f&oe=5BEA3066