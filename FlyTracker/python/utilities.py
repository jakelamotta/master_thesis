import json
import time

#Class for file input/output handling
class FileHandler:
	
	#Method for saving to file, the object to save is converted into a
	#json-string that is then saved to file. To retrieve it it needs to be 
	#converted back to object form using json.loads()
	@staticmethod
	def saveToFile(toSave,fileName,*args):
		e = 'w'

		for arg in args:
			e = arg		
			
		try:
			f = open('/home/kristian/master_thesis/FlyTracker/data/'+fileName,e)
			output = json.dumps(toSave)
			f.write(output)
	
		except IOError:
			FileHandler.logException("Couldnt save to file")
			
	
	#Method for loading from file, provide path to file as input
	#Output is object retrieved from the json-string 
	@staticmethod
	def loadFromFile(fileName,*args):
				
		try:
			f = open('/home/kristian/master_thesis/FlyTracker/data/'+fileName,'r')
			input_ = f.read()
			obj = json.loads(input_)
		except IOError:
			FileHandler.logException("Couldnt load from file, file missing or path is wrong")
			obj = None		
		return obj
	
	
	@staticmethod
	def logException(exception_message):
		output = exception_message+' '+time.asctime(time.localtime())+'\n'
		FileHandler.saveToFile(output,'log.txt','a')

#General utility class with functions for manipulating data
class Utilities:

	@staticmethod
	def padNumber(number,length):
		newNr = str(number)
		while len(newNr) != length:
			newNr = '0'+newNr	
		return newNr
	
	@staticmethod
	def toSigned(n):
		return n - ((0x80 & n) << 1)
	
	@staticmethod
	def convert2DCoordsTo3DCoords(dx1,dx2,dy1,dy2):

		newdx = 0
		newdy = 0
		newAngle = 0

		return newdx,newdy,newAngle
