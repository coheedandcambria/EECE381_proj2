import RPi.GPIO as GPIO
from time import sleep


# purpose of program is to Send signals based on user id that the user can control

GPIO.setmode(GPIO.BOARD) 
GPIO.setwarnings(False)

dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 #12 
ackPin = 36 #16
doneTransmit = 37 #26

GPIO.setup(dataPins, GPIO.OUT) 
GPIO.setup(valid, GPIO.OUT) 
GPIO.setup(ackPin, GPIO.IN)
GPIO.setup(doneTransmit, GPIO.OUT)

text = '1'
while (text != '0'):
	# FOR DEBUG
	user = 1 # ADMIN
	
	# user inputs a string, it is then converted to binary and sent to the DE2
	if (user == 1):
		print "logged in as admin, please send a numerical command"
		print "0: Log Out, 1: Toggle Green LED, 2: Toggle Red LED"
	text = raw_input('Command: ') 
	print text
	# print the binary value of the characters in the string
	if (text != '0'):	
		GPIO.output(dataPins , False)
		GPIO.output(valid, False)
		GPIO.output(doneTransmit, False)
		
		print(' '.join(format(ord(x), 'b') for x in text))
		letters = ' '.join(format(ord(x), 'b') for x in text)
	
		list = letters.split()
		print('Sending:\n ')
		for i in range(len(list)) :
			ar = [0] * 7
			x = int(list[i])
		#	GPIO.output(valid, True)
			for i in range (7):
				ar[i] = x%2
				x = x/10*1
				print ar[i]
				# Now send that bit over the corresponding pin
				GPIO.output(dataPins[i], ar[i])
			print('\n')
			GPIO.output(valid, True)
		#	sleep(3)
			while GPIO.input(ackPin) == False:
		#		#do nothing until DE2 tells us the message was received
				GPIO.output(valid, True)
			GPIO.output(valid, False)
			GPIO.output(dataPins, False)
		
		print "Done transmit"
		GPIO.output(doneTransmit, True)
		sleep (1)
		GPIO.output(doneTransmit, False)
		GPIO.output(valid, False)
	else:
		print"logging out"
GPIO.cleanup()
