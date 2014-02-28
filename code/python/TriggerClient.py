import socket
import sys
import traceback
import os
import utilities as u

#Send trigger signal to trigger server
def sendTrigger():

	#Hardcode this variable
	pipe = ""

	try:

		s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)	
		host = 'stimuli-hp'
		port = 4444		
		s.connect((host,port))
		
		print 'Connected to: ',s.getpeername(),'... sending start command..'

		#Runs until quit command is recieved from stiumli software
		while True:

			#Reads from pipe
			cmd = open(pipe).read().strip()
			s.sendall(cmd[0])
						
			if cmd[0] == 'q':
				break
		

		s.close()	#Close connection when done

	except Exception:
		print 'Couldnt connect to server'
		print traceback.format_exc()

if __name__ == '__main__':
	sendTrigger()
		
