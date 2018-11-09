import os
import requests

fbURL = input("Insert the video link: ")

fbURL = fbURL.replace("www", "m")

print(fbURL)
# r = requests.get(fbURL)
# os.system('wget "' + fbURL + '"')

# url = "https:\/\/video.fcpv4-1.fna.fbcdn.net\/v\/t42.9040-2\/45596286_1262552537245135_1625987769731907584_n.mp4?_nc_cat=1&efg=eyJ2ZW5jb2RlX3RhZyI6InN2ZV9zZCJ9&_nc_ht=video.fcpv4-1.fna&oh=e5382785cfac9aff54c2944357e5e41a&oe=5BE5139E"

# videoUrl = url.replace("\/", "/")

# os.system('wget -O "video.mp4" "' + videoUrl + '"')