import socket
import sys

def sendTrigger(param):
	
	s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)	
	host = '127.0.0.1'
	port = 3000
	s.connect((host,port))

	if param == 'quit':
		s.sendall('q')
	elif param == 'pause':
		s.sendall('p')
	elif param == 'start':
		s.sendall('s')
	print s.getpeername()

	s.close()

if __name__ == '__main__':

	try:
		arg = sys.argv[1]
		sendTrigger(arg)
	except IndexError:
		print 'Not enough parameters provided'
	
		
