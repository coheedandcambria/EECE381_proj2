import RPi.GPIO as GPIO
from time import sleep


# purpose of program is to toggle leds on the DE2 by sending bytes of data and communicating with DE2 through handshaking protocol
# Set up GPIO

GPIO.setmode(GPIO.BOARD) 
GPIO.setwarnings(False)

dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 #12 
ackPin = 36 #16
doneTransmit = 37 #26
readWrite = 13 				#4 on the cobbler

GPIO.setup(dataPins, GPIO.OUT) 
GPIO.setup(valid, GPIO.OUT) 
GPIO.setup(ackPin, GPIO.IN)
GPIO.setup(doneTransmit, GPIO.OUT)
GPIO.setup(readWrite, GPIO.OUT)


# user inputs a string, it is then converted to binary and sent to the DE2
text = raw_input('Please enter your username: ') 
print text
# print the binary value of the characters in the string

GPIO.output(dataPins , False)
GPIO.output(valid, False)
GPIO.output(doneTransmit, False)
GPIO.output(readWrite, True)		# initialize the pi in write mode

print(' '.join(format(ord(x), 'b') for x in text))
letters = ' '.join(format(ord(x), 'b') for x in text)

list = letters.split()
print('Sending:\n ')
for i in range(len(list)) :
	ar = [0] * 7
	x = int(list[i])
	GPIO.output(valid, True)
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
