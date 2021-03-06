import socket

HOST = "127.0.0.1"
PORT = 9393

# gamemode = "default"
# gamemode = "fast"
gamemode = "double"
start_msg = "start " + gamemode

right = "right"
left = "left"
up = "up"
down = "down"
move = "Move: "
break_line = "\n"

MAX_Y = 21
MAX_X = 34

def moveX(step):
    if step > 0:
        move_str = move + right + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + left + break_line
        client.sendall(move_str.encode())

def moveY(step):
    if step > 0:
        move_str = move + down + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + up + break_line
        client.sendall(move_str.encode())

def decmps(host_msg):
    msg_list = host_msg.split("\n")
    block_x = msg_list[0]
    block_y = msg_list[1]
    ball_x = msg_list[2]
    ball_y = msg_list[3]
    block_x = int(block_x.split(" ")[1])
    block_y = int(block_y.split(" ")[1])
    ball_x = [int(i) for i in ball_x.split(" ") if i != "ballx:"]
    ball_y = [int(i) for i in ball_y.split(" ") if i != "bally:"]
    return block_x, block_y, ball_x, ball_y

win = "win"
lose = "lose"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))
client.sendall(start_msg.encode())

while True:
    server_msg = str(client.recv(1024), encoding="utf-8")
    if server_msg[:3] == win or server_msg[:4] == lose:
        print(server_msg)
        break
    if server_msg[:4] == "give":
        continue    
    block_x, block_y, ball_x, ball_y = decmps(server_msg)

    # for default and fast mode
    # moveX(ball_x[0] - block_x)
    # moveY(ball_y[0] - block_y)
    
    # for double mode
    if min(ball_x) < MAX_X-max(ball_x):
        idx = ball_x.index(min(ball_x))
        moveY(ball_y[idx] - block_y)
    else:
        idx = ball_x.index(max(ball_x))
        moveY(ball_y[idx] - block_y)
    
    if min(ball_y) < MAX_Y-max(ball_y):
        idx = ball_y.index(min(ball_y))
        moveX(ball_x[idx] - block_x)
    else:
        idx = ball_y.index(max(ball_y))
        moveX(ball_x[idx] - block_x)

client.close()
