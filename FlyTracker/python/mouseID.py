import DAQ
import utilities
import traceback

	
def idMouse():
	global micePositions
	mice = []	
	
	for i in range(0,3):
		m = DAQ.IdMouse(i)
		m.setDaemon(True)
		m.start()	
		mice.append(m)		

	run = True	
	while run:
		for mouse_ in mice:
			if mouse_.id != -1:
				miceMapping['mouse'] = mouse_.id
				micePositions.remove(mouse_.id)				
				run = False
	
	idSensors()

	print miceMapping['mouse']
	print miceMapping['sensor2']
	print miceMapping['sensor1']
	utilities.FileHandler.saveToFile(miceMapping,'mice.txt')
	
	

def idSensors():
	global micePositions

	miceMapping['sensor1'] = micePositions.pop(0)
	miceMapping['sensor2'] = micePositions.pop(0)	
		

if __name__ == "__main__":
	micePositions= [0,1,2,3] 		
	miceMapping = {'sensor1':None,'sensor2':None,'mouse':None}
	idMouse()
