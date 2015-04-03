import RPi.GPIO as GPIO
from time import sleep

GPIO.setmode(GPIO.BOARD) 
GPIO.setwarnings(False)

dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 #12 
ackPin = 36 #16
doneTransmit = 37 #26
readWrite =  7				#4 on the cobbler
	
# RECEIVE USER NAME AKNOWLEDGED FROM THE DE2

GPIO.setup(dataPins, GPIO.IN) 
GPIO.setup(valid, GPIO.IN) 
GPIO.setup(ackPin, GPIO.OUT)
GPIO.setup(doneTransmit, GPIO.IN)
GPIO.setup(readWrite, GPIO.OUT)


GPIO.output(readWrite, False)		# initialize the pi in read mode
	
# WAIT FOR VALID BIT FROM DE2
print "test"
string = ''
x = 0

while GPIO.input(valid) != 1:			# wait for valid to be true
	GPIO.output(ackPin , False)
while GPIO.input(doneTransmit) != 1:		# read until the done transmit signal arrives
	# wait for valid bit
	while GPIO.input(valid) != 1:
		#do nothing
		GPIO.output(ackPin,  False)
	
	#we have a valid signal, read each of the bits into an array and then concatenate them
	ar = [0] * 7
	sum = 0
	for i in range (7):
		ar[i] = str(GPIO.input(dataPins[i]))
		print ar[i]
		
		#convert the binary to a decimal value
		sum += GPIO.input(dataPins[i]) * 2 ** i	
	
	#send acknowledge to DE2
	GPIO.output(ackPin, True)
#	sleep(5)
	# wait for valid to go to false
	while GPIO.input(valid) == True:
		# do nothing
		GPIO.output(ackPin, True)
	GPIO.output(ackPin, False)

	string += chr(sum)	

print string

#hardcode an accepted message for debug

if string == "Phil":
	print "Welcome: " + string + ", please scan your ID badge "
	user_valid = 1
else:
	print "Username: " + string + " was not valid"
