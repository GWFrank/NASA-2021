#!/usr/bin/env python3

import socket
import random
import hashlib
import time
from tqdm import tqdm
import json

HOST = f'linux9.csie.ntu.edu.tw'
PORT = 13087


def interactive(s):
    while True:
        try:
            buf = input()
        except KeyboardInterrupt:
            break
        try:
            sendLine(s, buf)
            print(recvAll(s).decode(), end='')
        except BrokenPipeError:
            break


def recvUntil(s, suffix):
    suffix = suffix.encode() if isinstance(suffix, str) else suffix
    ret = b''
    while True:
        c = s.recv(1)
        ret += c
        if ret.endswith(suffix):
            break
    return ret


def recvLine(s):
    return recvUntil(s, '\n')


def recvAll(s):
    return s.recv(100000)


def sendLine(s, buf):
    buf = buf.encode() if isinstance(buf, str) else buf
    return s.sendall(buf + b'\n')


def POW(s):
    line = recvUntil(s, ' : ').decode()
    for i in tqdm(range(2**24)):
        if hashlib.md5(f'{i}'.encode()).hexdigest()[0:8] == line[38:46]:
            sendLine(s, str(i))
            break


if __name__ == '__main__':
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT))
        POW(s)
        print(recvUntil(s, ': ').decode(), end='')
        interactive(s)

        # 5.
        # with open('rainbow.json') as json_file:
        #     rainbow = json.load(json_file)
        # sendLine(s, "3")
        # for i in range(10):
        #     task = recvUntil(s, ': ').decode()
        #     print(task, end='')
        #     q = task[-12:-4]
        #     sendLine(s, str(rainbow[q]))
        #     print(q, str(rainbow[q]))
        # interactive(s)

        # 3.
        # case_str = "1"
        # for i in range(2, 7200):
        #     if i%2 == 0:
        #         case_str = case_str+f" {i}"
        #     else:
        #         case_str = f"{i} "+case_str
        # sendLine(s, "1")
        # print("")
        # print(recvUntil(s, ': ').decode(), end='')
        # print("")
        # sendLine(s, case_str)
        # print("")
        # interactive(s)

