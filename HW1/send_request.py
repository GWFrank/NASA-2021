import requests

hostname = "http://nasahw1.csie.ntu.edu.tw"
url = hostname + "/na/http/login.html"

params = {
    "user": "account",
    "pass": "b09902004"
}

page = requests.get(url, params)
print(page.text)