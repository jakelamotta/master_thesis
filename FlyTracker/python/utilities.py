import json
import time

####EDIT START##########

path = '/home/kristian/master_thesis/' #set to location of FlyTracker folder

####EDIT STOP###########

path_pipe = path+'FlyTracker/data/pipe'
path_data = path+'FlyTracker/data/'#'/home/kristian/master_thesis/FlyTracker/data/'




#Class for file input/output handling
class FileHandler:
	
	#Method for saving to file, the object to save is converted into a
	#json-string that is then saved to file. To retrieve it it needs to be 
	#converted back to object form using json.loads()
	@staticmethod
	def saveToFile(toSave,fileName,*args):
		e = 'w'
		global path_data

		for arg in args:
			e = arg		
			
		try:
			f = open(path_data+fileName,e)
			output = json.dumps(toSave)
			f.write(output)
	
		except IOError:
			FileHandler.logException("Couldnt save to file")
			
	
	#Method for loading from file, provide path to file as input
	#Output is object retrieved from the json-string 
	@staticmethod
	def loadFromFile(fileName,*args):
		global path_data
	
		try:
			f = open(path_data+fileName,'r')
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

#General utility class with functions for data handling
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
	def getPath(arg):
		global path, path_pipe
		if arg == 'pipe':
			return path_pipe
		elif arg == 'data':
			return path_data



