import socket, time

HOST = 'fe80::5054:ff:fecf:12d9'
PORT = 9453
client = socket.socket(socket.AF_INET6, socket.SOCK_STREAM, 0)
client.connect(('fe80::5054:ff:fecf:12d9', 9453, 0, 0))
for _ in range(10):
    server_msg = str(client.recv(1024), encoding="utf-8")
    print(server_msg)
    time.sleep(1)
client.close()
