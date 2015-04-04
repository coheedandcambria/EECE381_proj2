import RPi.GPIO as GPIO
from time import sleep


# purpose of program is to toggle leds on the DE2 by sending bytes of data and communicating with DE2 through handshaking protocol
# Set up GPIO


GPIO.setmode(GPIO.BOARD) 
GPIO.setwarnings(False)

# Writing Pins
dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 				#12 
ackPin = 36 				#16
doneTransmit = 37 			#26
# Reading Pins
dataIn = [3, 5, 13, 21, 23, 33, 35]	# SDA, SCL, 27, MOSI, MISO, 13, 19
validIn = 18				#24
ackOut = 24 				#CE0
doneIn = 26 				#ce1

readWrite =  7				#4 on the cobbler



GPIO.setup(dataPins, GPIO.OUT) 
GPIO.setup(valid, GPIO.OUT) 
GPIO.setup(ackPin, GPIO.IN)
GPIO.setup(doneTransmit, GPIO.OUT)
GPIO.setup(readWrite, GPIO.OUT)

GPIO.setup(dataIn , GPIO.IN)
GPIO.setup(validIn, GPIO.IN)
GPIO.setup(doneIn, GPIO.IN)
GPIO.setup(ackOut, GPIO.OUT)


GPIO.output(dataPins , False)
GPIO.output(valid, False)
GPIO.output(doneTransmit, False)
GPIO.output(readWrite, True)		# initialize the pi in write mode

# user inputs a string, it is then converted to binary and sent to the DE2
text = raw_input('Please enter your username: ') 
print text
# print the binary value of the characters in the string

print(' '.join(format(ord(x), 'b') for x in text))
letters = ' '.join(format(ord(x), 'b') for x in text)

list = letters.split()
print('Sending:\n ')
for i in range(len(list)) :
	ar = [0] * 7
	x = int(list[i])
	for i in range (7):
		ar[i] = x%2
		x = x/10*1
		print ar[i]
		# Now send that bit over the corresponding pin
		GPIO.output(dataPins[i], ar[i])
	print('\n')
	GPIO.output(valid, True)
	sleep(3)
	while GPIO.input(ackPin) == False:
#		#do nothing until DE2 tells us the message was received
		GPIO.output(valid, True)
	GPIO.output(valid, False)
	GPIO.output(dataPins, False)

print('Done transmit')
GPIO.output(doneTransmit, True)
sleep (4)
GPIO.output(doneTransmit, False)
GPIO.output(valid, False)
GPIO.cleanup()


# now receive response from DE2

GPIO.setmode(GPIO.BOARD) 
GPIO.setwarnings(False)

dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 #12 
ackPin = 36 #16
doneTransmit = 37 #26
readWrite = 7 				#4 on the cobbler

	
# RECEIVE USER NAME AKNOWLEDGED FROM THE DE2

GPIO.setup(dataPins, GPIO.IN) 
GPIO.setup(valid, GPIO.IN) 
GPIO.setup(ackPin, GPIO.OUT)
GPIO.setup(doneTransmit, GPIO.IN)
GPIO.setup(readWrite, GPIO.OUT)

GPIO.output(readWrite, False) 	# pi is now in read mode

	
# WAIT FOR VALID BIT FROM DE2
print "test reception"
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
	sleep(5)
	# wait for valid to go to false
	while GPIO.input(valid) == True:
		# do nothing
		GPIO.output(ackPin, True)

	GPIO.output(ackPin, False)

	string += chr(sum)	

print string

#hardcode an accepted message for debug

if string == "username valid":
	print "Welcome: " + received + ", please scan your ID badge "
	user_valid = 1
else:
	print "Username: " + string + " was not valid"
