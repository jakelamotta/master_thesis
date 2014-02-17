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
			
			if sum_ > 0:
				#.append(t)
				timestamp.append(time.time())
				print padNumber(coords[0]),padNumber(coords[1]),padNumber(coords[2]),padNumber(coords[3])
			
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

def padNumber(number):
	newNr = str(number)
	while len(newNr) != 5:
		newNr = '0'+newNr	
	return newNr

def TriggerSocket(port):
	
	#print("Running on port " + str(port))
	try:
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.bind(('localhost',port))
		s.listen(1)
		s.settimeout(30)	

		connection, addr = s.accept()     # Establish connection with client.
		handler = MouseHandler()
				
		handler.start()
			
		#print 'Got connection from', addr 
	
		address = addr
		connection.send(str("T"))	     	
		#connection.close()

		while True:
			connection, addr = s.accept()     # Establish connection with client.
			
			if address[0] == addr[0]:
				handler.run_ = False
				handler.s1.mouse
				connection.send(str(handler.run_))
				break
		
	except Exception:
		utilities.FileHandler.logException(traceback.format_exc())	
	finally: 
		s.shutdown(socket.SHUT_RDWR)
		try:
			connection.close()                # Close the connection
		except UnboundLocalError:
			pass

	
if __name__ == '__main__':
	TriggerSocket(3000)

