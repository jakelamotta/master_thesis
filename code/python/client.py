import socket

s = socket.socket()
host = 'localhost'
port = 3000

s.connect((host,port))



while True:
	msg = s.recv(1)
	if msg == 'T' or msg == 'F':
		print msg
		break
	
s.close()


