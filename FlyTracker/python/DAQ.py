import sys
import threading
import socket
import utilities
import traceback
import time
import os



#Global variables
coords = [0,0,0,0]
mice_ = ['mouse0','mouse1','mouse2','mouse3','mouse4']
defaultPort = 3000 #Default port value for the trigger server to be listening on
pipe = utilities.Utilities.getPath('pipe')

running = True

#Handles the mice sensors, inherits from Thread as it continously polls the coord variable
#which in return is written to by the mice.
class MouseHandler(threading.Thread):
	
	#Default constructor, set up the mouse sensors
	def __init__(self):
		self.sensors = []
		self.triggerMouse = None
		self.mouseIDs = utilities.FileHandler.loadFromFile('mice.txt');
		self.run_ = True
		self.pause = False

		self.s1 = SensorMouse("sensor1",self.mouseIDs["sensor1"],self)
		self.s2 = SensorMouse("sensor2",self.mouseIDs["sensor2"],self)
		
		super(MouseHandler,self).__init__()
		
	def stop(self):
		self.run_ = False;

	#Overriden run-method, inefficient and should be revised. Dominated by pointless iterations due
	#to lack of good solution for pausing it from the outside. 
	def run(self):
		global coords
		
		try:	
			#Daemon threads are all closed (not clean close) when all non-daemon threads are terminated
			self.s1.setDaemon(True)
			self.s2.setDaemon(True)	
			
			#Run the threads			
			self.s1.start()
			self.s2.start()
		
		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())
		
		start = time.time()
		
		flag = True #flag for determining whether blockmarker has been added or not
		while self.run_:					
			sum_ = 0	
			
			if sum(coords) < 0:
				sum_ = -sum(coords)
			else:
				sum_ = sum(coords)
			
			if sum_ > 0 and not self.pause:
				flag = True
			
				utilities.FileHandler.saveToFile(utilities.Utilities.padNumber(int(round((time.time()-start)*1000)),6),'temptime.txt','append')
				
				utilities.FileHandler.saveToFile(utilities.Utilities.padNumber(coords[0],5),'tempdata.txt','append')
				utilities.FileHandler.saveToFile(utilities.Utilities.padNumber(coords[1],5),'tempdata.txt','append')			
				utilities.FileHandler.saveToFile(utilities.Utilities.padNumber(coords[2],5),'tempdata.txt','append')		
				utilities.FileHandler.saveToFile(utilities.Utilities.padNumber(coords[3],5),'tempdata.txt','append')

			if self.pause and flag:
				utilities.FileHandler.saveToFile('*','tempdata.txt','append')
				utilities.FileHandler.saveToFile('*','temptime.txt','append')
				flag = False

			coords = [0,0,0,0]		
		
	def addMouse(self,mouse):
		self.sensors.append(mouse)


#Super class to teh different mouse classes. 
class AbstractMouse(threading.Thread):

	def __init__(self,nr,handler):
		global mice_
		
		self.number = nr
		self.prefix = '/dev/input/'
		self.mouse = None
				
		try:
			str1 = self.prefix + mice_[self.number]
			self.mouse = file(str1)
		except IOError:
			utilities.FileHandler.logException("Mouse "+self.id+" was not found:"+str1)

		super(AbstractMouse,self).__init__()

#Id-mouse used to id itself
class IdMouse(AbstractMouse):

	def __init__(self,nr):
		self.id = -1
		self.run_ = True
		super(IdMouse,self).__init__(nr,None)

	#Simple method to identfiy which mouse is which
	def run(self):
		while self.run_:
			status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))	
			self.id = self.number				
			
#Sensor mouse, provides functions for reading mouse delta coordinates	
class SensorMouse(AbstractMouse):

	def __init__(self,identifier,nr,h):
		self.id = identifier
		self.number = nr
		self.handler = h	
		super(SensorMouse,self).__init__(nr,h)
		
	
	def run(self):
		global coords
		
		#Reads mouse delta coordinates and write them to the global coord array
		while self.handler.run_:
			status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))
			dx = utilities.Utilities.toSigned(dx)
			dy = utilities.Utilities.toSigned(dy)
					
			if self.id == 'sensor1':			
				coords[0] = dx
				coords[1] = dy
			elif self.id == 'sensor2':			
				coords[2] = dx
				coords[3] = dy

#Class for handling the network connection
class socketHandler(threading.Thread):

	def __init__(self,p):
		self.port = p
		self.handler = MouseHandler()
		self.handler.setDaemon(True) #Setting thread to daemon means its terminated as all non-threads are terminated (not a clean exit)

		super(socketHandler,self).__init__()

	def run(self):

		try:
			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			
			s.bind(('',self.port)) #Using '' is prefferable compared to IP-address
			s.listen(1)
			s.settimeout(120)	
		
			print 'connection is running on localhost'
			connection, addr = s.accept()     # Establish connection with client.
			print 'Connection accepted from ',addr
	
			msg = connection.recv(1)
		
			if msg == 's':
				print 's'
				self.handler.start()
			
			else:
				print 'Not correct msg ',msg
		
		
			#Runs until client process sends 'quit'-command		
			while self.handler.run_:
			
				connection.close()
				connection, addr = s.accept()     # Establish connection with client.
			
				trigger = connection.recv(1)

				print 'Message rec: ',trigger
				if trigger == 'p':
					self.handler.pause = True
				elif trigger == 's':
					self.handler.pause = False
		

		except Exception:
			print traceback.format_exc()
			utilities.FileHandler.logException(traceback.format_exc())	
		finally: 
			s.shutdown(socket.SHUT_RDWR)

			try:
				connection.close()                # Close the connection
			except UnboundLocalError:
				pass
				


#Listens on socket for signal from trigger client. Can start, pause and stop readings
def runWithNetworkTrigger(args):
	port = int(args['port'])
	
	handler = socketHandler(port)
	handler.setDaemon(True)
	handler.start()

	#Reads from pipe as soon as anything is read it stops and all daemon threads are closed aswell
	open(pipe).read().strip()

	

#Run DAQ with timer
#Paramter time should be in ms
def runWithTimer(args):
	handler = MouseHandler()
	handler.start()
	
	time.sleep(int(args['time'])/1000)

	handler.stop()	

#Run DAQ without trigger, uses named pipe to communicate with matlab
def runWithoutTrigger(args):
	global pipe

	handler = MouseHandler()
	handler.start()

	#Reads from pipe as soon as anything is written it stops
	open(pipe).read().strip()

	handler.stop()
	

#Function for parsing system args. 
def parseArgs(args):
	output = {}
	output['function'] = args[1]	

	for index in range(2,len(args),2):
		output[args[index]] = args[index+1]
		
	return output

#Code that is run when calling DAQ.py
if __name__ == '__main__':
	#Precondition:
	#System args must be in the form: 'function' 'parameter1' 'value1' 'parameter2' 'value2'...	


	#Function map 
	functions = {'network':runWithNetworkTrigger, 'notrigger':runWithoutTrigger, 'timer':runWithTimer}	
	args = parseArgs(sys.argv) #sys.argv are arguments provided when calling function from commandline

	#Launch provided function label
	functions[args['function']](args)
	
