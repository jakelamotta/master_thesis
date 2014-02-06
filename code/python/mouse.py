import json
import thread
import threading
import time
import sys

mice = ['mouse0','mouse1','mouse2','mouse3','mouse4',]
coords = [0,0,0,0]


class Mouse(threading.Thread):

	def __init__(self,identifier):
		self.threadid = identifier
		self.prefix = '/dev/input/'

		threading.Thread.__init__(self)
		self.run()
  	

class MouseHandler(object):
	
	def __init__(self):
		self.mice = []
		self.mouseIDs = ['mouse0','mouse1','mouse2','mouse3','mouse4',]
		

	def addMouse(mouse):
		self.mice.append(mouse)

	def removeMouse(mouse):
		self.mice.remove(mouse)
		
		
class SensorMouse(Mouse):

	def __init__(self):
		self.coords = [0,0]
		super().__init__(self)
		readMouse()

	#Read mouse input, data that is retrieved is delta x and delta y values for the mouse
	def readMouse():
		while True:
			status, dx, dy = tuple(ord(c) for c in self.read(3))
			dx = toSigned(dx)
			dy = toSigned(dy)
		
			self.coords[0] = dx
			self.coords[1] = dy


class TriggerMouse(Mouse):
	
	def __init__(self, _threshold):
		self.timeReference = 0
		self.triggered = False
		self.threshold = _threshold
		super().__init__(self)
		readMouse()
	
	def readMouse():
		while True:
			status,dx,dy = tuple(ord(c) for c in self.read(3))
			dx = toSigned(dx)
			dy = toSigned(dy)
	
			if dx != 0 or dy != 0:
				if(self.timeReference == 0):
					self.timeReference = time.time() 
								
				self.triggered = True
				
				if not aboveThreshold():
					self.triggerd = False
					self.timeReference = 0

	def aboveThreshold():
		
		return True 
		
class Fly(object):

	def __init__(self):
		#Position defined as [x,y,angle] where x and y are coordinates in the xy-plane
		#and the angle is defined as the angle between the fly's direction and the y-axis 
		self.position = [0,0,0]
		

	#Function for calculatiing ball rotation speed given tangential speeds for two points on the 		#ball.
	###########################################################
	#Input: c1 and c2 must be coordniate vectors of length 2
	###########################################################
	#Output: Returns forward, sideways and rotational velocity of the fly
	def calcFlyVelocity(c1,c2):

		ballVelFrwrd = (c1[1]+c2[1])*cos(y)
		ballVelSide = (c1[1]+c2[1])*sin(y)
		ballVelRot = (c1[0]+c2[0])/2

		flyVelFrwrd = -ballVelFrwrd
		flyVelSide = -ballVelSide
		flyVelRot = ballVelRot

		return flyVelFrwrd, flyVelSide, flyVelRot

	#Update fly position given its velocity
	def updatePosition(c1,c2):
		velFrwrd, velSide, velRot = calcFlyVelocity(c1,c2)
		
		self.position[2] = self.position[2]+velRot*dt
 		self.position[1] = self.position[1]+velSide*sin(self.position[2])+velFrwrd*sin(self.position[2])
		self.position[0] = self.position[0]+velSide*cos(self.position[2])-velFrwrd*sin(self.position[2])	
 					

class Recording(object):

	def __init__(self):
		pass

#Init each mouse
def initMice(first,second):
	mouse1_, mouse2_ = None,None
	try:
		str1 = '/dev/input/' + mice[first]
	
		mouse1_ = file(str1)
	except IOError:
		print "Mouse 2 was not found"
		try:	
			str2 = '/dev/input/'+mice[second]
			mouse2_ = file(str2)
		except IOError:
			print "Mouse 1 was not found"
	return mouse1_, mouse2_

def toSigned(n):
	return n - ((0x80 & n) << 1)

#Read mouse input, data that is retrieved is delta x and delta y values for the mouse
def readMouse(m,thread,*args):
	global coords
	
	while True:
		status, dx, dy = tuple(ord(c) for c in m.read(3))
		dx = toSigned(dx)
		dy = toSigned(dy)
	
		if thread == 'thread1':
			coords[0] = dx
			coords[1] = dy                
		elif thread == 'thread2':
			coords[2] = dx
			coords[2] = dy


def readData():
	m1,m2 = initMice(0,1)
	global coords
	#One thread for each mouse that listens for mouse data
	try:
		thread.start_new_thread(readMouse,(m1,'thread1',1))
		#thread.start_new_thread(readMouse,(m2,'thread2',2))
	except:
		print "Error: unable to start thread"

	#Temp code, breaks loop after 
	t = 0
	sum_ = 0
	a = []
	timestamp = []
	start = time.time() 	
	
	while True:
		sum_ = 0	
		if sum(coords) < 0:
			sum_ = -sum(coords)
		else:
			sum_ = sum(coords)
				
		if sum_ > 0:
			a.append(t)
			timestamp.append(time.time())

		coords = [0,0,0,0]
		t += 1
		if t == 10000000:
			break

	end = time.time()
	delta = end-start
	print "ran for %d" % (delta)
	return a,timestamp
	
def measure():
    t0 = time.time()
    t1 = t0
    while t1 == t0:
        t1 = time.time()
    return (t0, t1, t1-t0)


if __name__ == "__main__":
	samples = [measure() for i in range(10)]

	print reduce( lambda a,b:a+b, [measure()[2] for i in range(1000)], 0.0) / 1000.0	
		
	#s,a=readData()	

	
	
	#try:
	#	f = open('/home/kristian/master_thesis/code/python/t.txt','w')
	#	output = json.dumps(s)
	#	output.replace('[','')
	#	output.replace(']',',')
	#	f.write(output)
	#except IOError:
	#	print "could not write to file"

	#try:
	#	f = open('/home/kristian/master_thesis/code/python/time.txt','w')
	#	output = json.dumps(a)
	#	output.replace('[','')
	#	output.replace(']',',')
	#	f.write(output)
	#except IOError:
	#	print "Could not write to file"
