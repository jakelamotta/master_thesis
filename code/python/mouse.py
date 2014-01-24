import thread

try:
	mouse1_ = file('/dev/input/mouse0')

except IOError:
	print "Mouse 0 was not found"

try:
	mouse2_ = file('/dev/input/mouse1')
except IOError:
	print "Mouse 1 was not found"

try:
	key = file('/dev/input/keyboard')
except IOError:
	print "Keyboard not found"


def to_signed(n):
        return n - ((0x80 & n) << 1)


def mouse(m,mystring,*args):

        while True:
                status, dx, dy = tuple(ord(c) for c in m.read(3))
		dx = to_signed(dx)
                dy = to_signed(dy)
                print "%#02x %d %d" % (status, dx, dy)

try:
        thread.start_new_thread(mouse,(mouse1_,'thread1',1))
        thread.start_new_thread(mouse,(mouse2_,'thread2',2))
except:
        print "Error: unable to start thread"

while 1:
        pass 
