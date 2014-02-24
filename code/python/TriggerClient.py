import socket
import sys
import traceback

def sendTrigger(param):
	try:

		s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)	
		host = 'localhost'
		port = 4444
		s.connect((host,port))
		
		print 'Connected to: ',s.getpeername()

		if param == 'quit':
			s.sendall('q')
		elif param == 'pause':
			s.sendall('p')
		elif param == 'start':
			s.sendall('s')
		

		s.close()
	except Exception:
		print 'Couldnt connect to server'
		print traceback.format_exc()

if __name__ == '__main__':

	try:
		arg = sys.argv[1]
		sendTrigger(arg)
	except IndexError:
		print 'Not enough parameters provided'
	
		
