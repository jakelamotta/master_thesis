import time

def test():
	t = 0
	start = time.time()
	while t < 30000:
		t += 1
		time.sleep(0.002) 

	elapsed = time.time()-start
	print elapsed


test()
