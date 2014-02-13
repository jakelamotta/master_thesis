import utilities
import thread
import time
import traceback

coords = [0,0,0,0]		        

class Mouse(object):

	def idSelf(self,*args):
		start = time.time()

		if self.mouse != None:

			status,dx,dy = tuple(ord(c) for c in self.mouse.read(3))
			if dx != 0 or dy != 0:
				self.id = self.number
		
			elif round(time.time()-start) > 10.0:
				self.id =  -2
				

	def __init__(self,identifier,nr):
		self.mice_ = ['mouse0','mouse1','mouse2','mouse3','mouse4']
		self.number = nr
		self.threadid = identifier
		self.prefix = '/dev/input/'
		self.mouse = None
				
		try:
			str1 = self.prefix + self.mice_[self.number]
			self.mouse = file(str1)
		except IOError:
			utilities.FileHandler.logException("Mouse "+self.threadid+" was not found:"+str1)

		self.id = -1
  	
	
			


		
class SensorMouse(Mouse):
	
	def __init__(self,identifier,nr):
		super(SensorMouse,self).__init__(identifier,nr)

	#Read mouse input, data that is retrieved is delta x and delta y values for the mouse
	def readMouse(self,iden,*args):
		global coords		
		try:
			while True:
				status, dx, dy = tuple(ord(c) for c in self.mouse.read(3))
				dx = utilities.toSigned(dx)
				dy = utilities.toSigned(dy)
					
				if iden == 't1':			
					coords[0] = dx
					coords[1] = dy
				elif iden == 't2':			
					coords[2] = dx
					coords[3] = dy
		
		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())
	
class MouseHandler:
	
	def __init__(self):
		self.sensors = []
		self.triggerMouse = None
		self.mouseIDs = utilities.FileHandler.loadFromFile('mice.txt');
		
		s1 = SensorMouse("sensor1",self.mouseIDs["sensor1"])
		s2 = SensorMouse("sensor2",self.mouseIDs["sensor2"])
		
		self.addMouse(s1)
		self.addMouse(s2)
		
		try:
			thread.start_new_thread(s1.readMouse,("t1",2))	
			thread.start_new_thread(s2.readMouse,("t2",2))		
		except Exception:
			utilities.FileHandler.logException(traceback.format_exc())	
		
		sum_ = 0
		a = []
		timestamp = []
		start = time.time() 	
	
		

	def readData(self):
		global coords
		t = 0
		
		while t < 10000000:
			
			sum_ = 0	
			if sum(coords) < 0:
				sum_ = -sum(coords)
			else:
				sum_ = sum(coords)
			
			if sum_ > 0:
				#a.append(t)
				#timestamp.append(time.time())
				print padNumber(coords[0]),padNumber(coords[1]),padNumber(coords[2]),padNumber(coords[3])
			
			coords = [0,0,0,0]
			t += 1					
					

	def startMiceReading():
		pass
	
	def startTriggerReading():
		pass
	
	def addMouse(self,mouse):
		self.sensors.append(mouse)

	def removeMouse(self,mouse):
		self.sensors.remove(mouse)

def padNumber(number):
	newNr = str(number)
	while len(newNr) != 5:
		newNr = '0'+newNr	
	return newNr
		
if __name__ == '__main__':
	handler = MouseHandler()
	handler.readData()

		
