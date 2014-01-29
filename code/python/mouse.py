import thread
import time

#Global variable containing dx and dy readings from each sensor respectively
coords = [0,0,0,0]
mice = ['mouse0','mouse1','mouse2','mouse3','mouse4',]

#Init each mouse
def initMice(first,second):
	mouse1_, mouse2_ = None,None
	try:
		str1 = '/dev/input/' + mice[first]
		print str1
		mouse1_ = file(str1)

	except IOError:
		print "Mouse 0 or 2 wasnt found, add new mouse"

	try:	
		str2 = '/dev/input/'+mice[second]
		mouse2_ = file(str2)
	except IOError:
		print "Mouse 1 was not found"
	
	return mouse1_, mouse2_

def toSigned(n):
        return n - ((0x80 & n) << 1)

#Read mouse input, data that is retrieved is delta x and delta y values for the mouse
def readMouse(m,mystring,*args):
	global coords

        while True:
                status, dx, dy = tuple(ord(c) for c in m.read(3))
		dx = toSigned(dx)
                dy = toSigned(dy)
		
		if mystring == 'thread1':
			coords[0] = dx
			coords[1] = dy                
		elif mystring == 'thread2':
			coords[2] = dx
			coords[2] = dy


######################################
## x = position on x axis
## y = position on y axis
## angle = angle in x,y-plane
## dt = time intervall
## forVel = forward velocity
######################################
def updatePosition(x,y,angle,dt,forVel):
		
	newAngle = angle+rotationVel*dt
	newX = x + sideVel*cos(newAngle) - forVel*sin(newAngle)
	newY = y+ sideVel*sin(newAngle) + forVel*cos(newAngle)

	return newX, newY, newAngle

def merge():

	pass	


if __name__ == "__main__":
	m1,m2 = initMice(0,1)

	try:
	        thread.start_new_thread(readMouse,(m1,'thread1',1))
	        thread.start_new_thread(readMouse,(m2,'thread2',2))
	except:
	        print "Error: unable to start thread"
	t = 0
	while t < 3000:
	        print coords
		coords = [0,0,0,0]
		time.sleep(0.001)
		t += 1
