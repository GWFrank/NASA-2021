from flask import Flask
import psutil
import time
import datetime

app = Flask(__name__)
start_time = time.time()

def in_docker():
    """ Returns: True if running in a Docker container, else False """
    with open('/proc/1/cgroup', 'rt') as ifh:
        if 'docker' in ifh.read():
            return "Hello Docker!"
        else:
            return "You should run it in a container!"

@app.route("/monitor")
def monitor():
    return "<h1>" + in_docker() \
            + "<br>uptime: " + str(datetime.timedelta(seconds=round(time.time() - start_time, 0))) \
            + "<br>cpu: " + str(psutil.cpu_percent()) + "%" \
            + "<br>ram: " + str(psutil.virtual_memory().percent) + "%</h1>"

@app.route("/")
def home():
    return """
        <div id="app"></div>
        <script>
        function httpGet()
        {
            var xmlHttp = new XMLHttpRequest();
            xmlHttp.open( "GET", "/monitor", false ); // false for synchronous request
            xmlHttp.send( null );
            document.getElementById('app').innerHTML = xmlHttp.responseText;
        }
        setInterval(httpGet, 1000);
        </script>
    """

app.debug = True
app.run(host='0.0.0.0', port=8000)