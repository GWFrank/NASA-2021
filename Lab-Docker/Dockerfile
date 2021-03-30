FROM ubuntu:18.04

RUN apt update && apt-get install -y python3 python3-pip wget
RUN wget -O main.py https://gist.githubusercontent.com/jameshwc/18011f20b0025dd7923ea26dcc19ad46/raw/b38434ccbef1dfc3fad4a661c627e537d47e1922/main.py
RUN pip3 install flask psutil
CMD python3 main.py
