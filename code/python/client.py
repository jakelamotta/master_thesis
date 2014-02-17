import socket

s = socket.socket()
host = 'localhost'
port = 3000

s.connect((host,port))



while True:
	print s.recv(1)
	if s.recv(1) == 'T' or s.recv(1) == 'F':
		break
	
s.close()


