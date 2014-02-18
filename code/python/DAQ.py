import sys
import threading
import socket
import utilities
import traceback
import time
#import mouse

coords = [0,0,0,0]
mice_ = ['mouse0','mouse1','mouse2','mouse3','mouse4']

class MouseHandler(threading.Thread):
	
	def __init__(self):
		self.sensors = []
		self.triggerMouse = None
		self.mouseIDs = utilities.FileHandler.loadFromFile('mice.txt');
		self.run_ = True
		self.pause = False

		self.s1 = SensorMouse("sensor1",self.mouseIDs["sensor1"],self)
		self.s2 = SensorMouse("sensor2",self.mouseIDs["sensor2"],self)
		
		super(MouseHandler,self).__init__()
		

	def run(self):
		global coords
		
		try:	
			self.s1.setDaemon(True)
			self.s2.setDaemon(True)	
			self.s1.start()
			self.s2.start()
		
		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())
		
		timestamp = []
		while self.run_:
			sum_ = 0	
			if sum(coords) < 0:
				sum_ = -sum(coords)
			else:
				sum_ = sum(coords)
			
			if sum_ > 0 and not self.pause:
				#.append(t)
				timestamp.append(time.time())
				print utilities.padNumber(coords[0]),padNumber(coords[1]),padNumber(coords[2]),padNumber(coords[3])
			
			coords = [0,0,0,0]		
		
		try:
			utilities.FileHandler.saveToFile(timestamp,'timestamp.txt')		
		except IOError:
			utilities.FileHandler.logException("Couldnt save timestamp to file")		
	
	def addMouse(self,mouse):
		self.sensors.append(mouse)

	
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

class IdMouse(AbstractMouse):

	def __init__(self,nr):
		self.id = -1
		self.run_ = True
		super(IdMouse,self).__init__(nr,None)

	
	def run(self):
		while self.run_:
			status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))	
			self.id = self.number				
			
	
class SensorMouse(AbstractMouse):

	def __init__(self,identifier,nr,h):
		self.id = identifier
		self.number = nr
		self.handler = h	
		super(SensorMouse,self).__init__(nr,h)
		
	def run(self):
		global coords
		while self.handler.run_:
			status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))
			dx = utilities.toSigned(dx)
			dy = utilities.toSigned(dy)
					
			if self.id == 'sensor1':			
				coords[0] = dx
				coords[1] = dy
			elif self.id == 'sensor2':			
				coords[2] = dx
				coords[3] = dy

def parseArguments(args):
	pass		


def openTriggerSocket(port):
	#print 'listening on port: ',port
	try:
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.bind(('130.238.33.175',port))
		s.listen(1)
		s.settimeout(120)	

		connection, addr = s.accept()     # Establish connection with client.
		#connection.send("T")		     	
		#print s.gethostname()
		if connection.recv(1) == 's':
			handler = MouseHandler()
			handler.start()
			
		while handler.run_:
			
			connection.close()
			connection, addr = s.accept()     # Establish connection with client.
			
			trigger = connection.recv(1)
			
			if trigger == 'p':
				handler.pause = True
				connection.close()
				
				connection,addr = s.accept()
				handler.pause = False
			else:
				handler.run_ = False	
			
			
			
	except Exception:
		utilities.FileHandler.logException(traceback.format_exc())	
	finally: 
		s.shutdown(socket.SHUT_RDWR)

		try:
			connection.close()                # Close the connection
		except UnboundLocalError:
			pass

#Run DAQ with timer set in ms
def runWithTimer(time):

	start = time.time()

	handler = MouseHandler()
	handler.start()
	current = time.time()-start
	
	while time < current:
		current = time.time()-start

	handler.run_ = False	
		
	

	
if __name__ == '__main__':
	
	#args = parseArgs(sys.argvs)	
		
	openTriggerSocket(4444)

