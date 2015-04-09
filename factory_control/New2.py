
import cv2
import picamera
import picamera.array
import subprocess
import RPi.GPIO as GPIO
from time import sleep
from Tkinter import Tk, BOTH
from ttk import Frame, Button, Style

# Writing Pins
dataPins = [11, 12, 15, 16, 22, 29, 31]	#17, 18, 22, 23, 25, 5, 6 on the cobbler 
valid = 32 				#12 
ackPin = 36 				#16
doneTransmit = 37 			#26
# Reading Pins
dataIn = [3, 5, 13, 19, 21, 33, 35]	# SDA, SCL, 27, MOSI, MISO, 13, 19
validIn = 18				#24
ackOut = 24 				#CE0
doneIn = 26 				#ce1

readWrite =  7				#4 on the cobbler

class GUI(Frame):
	def __init__(self, parent):
		Frame.__init__(self, parent)
		self.parent = parent
		self.initUI()
	
	def initUI(self):
		self.parent.title("User Control")
		self.style = Style()
		self.style.theme_use("default")
		self.pack(fill=BOTH, expand=1)
		if (user == 1):
			ledgOnButton = Button(self, text="Turn On Green LEDs", command=self.ToggleOnLEDg)
			ledgOnButton.place(x=50,y=50)
			ledgOffButton = Button(self, text="Turn Off Green LEDs", command=self.ToggleOffLEDg)
			ledgOffButton.place(x=50,y=100)
			ledgPlusButton = Button(self, text="Turn Up Green LEDs", command=self.LEDgPlus)
			ledgPlusButton.place(x=50,y=150)
			ledgMinButton = Button(self, text="Turn Down Green LEDs", command=self.LEDgMinus)
			ledgMinButton.place(x=50,y=200)
			logoutButton = Button(self, text="Logout", command=self.Logout)
			logoutButton.place(x=200,y=50)
			profileButton= Button(self, text="Profile Mode", command=self.Profile)
			profileButton.place(x=50,y=250)
			quitButton = Button(self, text="Quit", command=self.quitProgram)
			quitButton.place(x=200,y=100)
		elif(user == 2):
			ledrOnButton = Button(self, text="Turn On Red LEDs", command=self.ToggleOnLEDr)
			ledrOnButton.place(x=50,y=50)
			ledrOffButton = Button(self, text="Turn Off Red LEDs", command=self.ToggleOffLEDr)
			ledrOffButton.place(x=50,y=100)
			logoutButton = Button(self, text="Logout", command=self.Logout)
			logoutButton.place(x=200,y=50)
			quitButton = Button(self, text="Quit", command=self.quitProgram)
			quitButton.place(x=200,y=100)
		elif(user == 3):
			ledgOnButton = Button(self, text="Turn On Green LEDs", command=self.ToggleOnLEDg)
			ledgOnButton.place(x=50,y=50)
			ledgOffButton = Button(self, text="Turn Off Green LEDs", command=self.ToggleOffLEDg)
			ledgOffButton.place(x=50,y=100)
			ledrOnButton = Button(self, text="Turn On Red LEDs", command=self.ToggleOnLEDr)
			ledrOnButton.place(x=50,y=150)
			ledrOffButton = Button(self, text="Turn Off Red LEDs", command=self.ToggleOffLEDr)
			ledrOffButton.place(x=50,y=200)
			logoutButton = Button(self, text="Logout", command=self.Logout)
			logoutButton.place(x=200,y=50)
			quitButton = Button(self, text="Quit", command=self.quitProgram)
			quitButton.place(x=200,y=100)

		elif(user == 4):
			ledgOnButton = Button(self, text="Turn On Green LEDs", command=self.ToggleOnLEDg)
			ledgOnButton.place(x=50,y=50)
			ledgOffButton = Button(self, text="Turn Off Green LEDs", command=self.ToggleOffLEDg)
			ledgOffButton.place(x=50,y=100)
			ledrOnButton = Button(self, text="Turn On External LED", command=self.ToggleOnGPIO)
			ledrOnButton.place(x=50,y=150)
			ledrOffButton = Button(self, text="Turn Off External LED", command=self.ToggleOffGPIO)
			ledrOffButton.place(x=50,y=200)
			logoutButton = Button(self, text="Logout", command=self.Logout)
			logoutButton.place(x=200,y=50)
			quitButton = Button(self, text="Quit", command=self.quitProgram)
			quitButton.place(x=200,y=100)

	def ToggleOnLEDg(self):
		sendString("glON")
		#string = receiveString()
		resetString()

	def ToggleOffLEDg(self):
		sendString("gOFF")
		resetString()
		#string = receiveString()
	def LEDgPlus(self):
		sendString("gPLS")
		resetString()
		#string = receiveString()
	def LEDgMinus(self):
		sendString("gMIN")
		resetString()
		#string = receiveString()
	def ToggleOnLEDr(self):
		sendString("rlON")
		resetString()
		#string = receiveString()
		
	def ToggleOffLEDr(self):
		sendString("rOFF")
		resetString()
		#string = receiveString()
		
	def ToggleOnGPIO(self):
		sendString("GPON")
		resetString()
		#string = receiveString()
		
	def ToggleOffGPIO(self):
		sendString("GOFF")
		resetString()
		#string = receiveString()
		
	def Logout(self):
		sendString("logO")
		resetString()
		#string = receiveString()
		self.parent.destroy()
		
	def quitProgram	(self):
		exit(0)

	def Profile (self):
		quit = "QUIT\n"
		result = "notq"
		while (result != quit):
			result = scanQR()
			sendString(result)
			resetString()	
		self.parent.destroy()
	

def guiMain():
	root = Tk()
	root.geometry("550x350+300+300")
	app = GUI(root)
	root.mainloop()

def initGPIO():
	# Set up GPIO
	
	GPIO.setmode(GPIO.BOARD) 
	GPIO.setwarnings(False)

	
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
	GPIO.output(ackOut, False)

def sendString(text):
	GPIO.output(readWrite, True)		# initialize the pi in write mode
#	print(' '.join(format(ord(x), 'b') for x in text))
	letters = ' '.join(format(ord(x), 'b') for x in text)
	
	list = letters.split()
#	print('Sending:\n ')
	for i in range(len(list)) :
		ar = [0] * 7
		x = int(list[i])
		for i in range (7):
			ar[i] = x%2
			x = x/10*1
#			print ar[i]
			# Now send that bit over the corresponding pin
			GPIO.output(dataPins[i], ar[i])
#		print('\n')
		GPIO.output(valid, True)
	#	sleep(3)
		while GPIO.input(ackPin) == False:
	#		#do nothing until DE2 tells us the message was received
			GPIO.output(valid, True)
		GPIO.output(valid, False)
		GPIO.output(dataPins, False)
	
#	print('Done transmit')
	GPIO.output(doneTransmit, True)
	#sleep (4)
	sleep(0.1)
	GPIO.output(doneTransmit, False)
	GPIO.output(valid, False)

def resetString():

	GPIO.output(readWrite, False) 	# pi is now in read mode
	sleep(0.1)	
	GPIO.output(ackOut, False)
	sleep(0.1)
	GPIO.output(ackOut, True)
	sleep(0.1)	


def receiveString():
	GPIO.output(readWrite, False) 	# pi is now in read mode
		
	# WAIT FOR VALID BIT FROM DE2
#	print "test reception"
	string = ''
	x = 0

	sleep(0.1)
	while GPIO.input(validIn) != 1:			# wait for valid to be true
		GPIO.output(ackOut , False)
		#sleep(0.1)
	while GPIO.input(doneIn) != 1:		# read until the done transmit signal arrives
		# wait for valid bit
		while GPIO.input(validIn) != 1:
			#do nothing
			GPIO.output(ackOut,  False)
		#	sleep(0.1)
		
		#we have a valid signal, read each of the bits into an array and then concatenate them
		ar = [0] * 7
		sum = 0
		for i in range (7):
			ar[i] = str(GPIO.input(dataIn[i]))
#			print ar[i]
			
			#convert the binary to a decimal value
			sum += GPIO.input(dataIn[i]) * 2 ** i	
		
		#send acknowledge to DE2
		GPIO.output(ackOut, True)
		#sleep(0.1)
	#	sleep(5)
		# wait for valid to go to false
		while GPIO.input(validIn) == True:
		#	sleep(0.1)
			# do nothing
			GPIO.output(ackOut, True)
	
		GPIO.output(ackOut, False)
		#sleep(0.1)
	
		string += chr(sum)	
	
	#print string
	return string

def scanQR():
	# scan Qr code id badge
	
	with picamera.PiCamera() as camera:
		with picamera.array.PiRGBArray(camera) as stream:
        		camera.resolution = (320, 240)
			qr_code = "       "
        		
        		while qr_code[:7] != "QR-Code":
        			camera.capture(stream, 'bgr', use_video_port=True)
        			# stream.array now contains the image data in BGR order
        			cv2.imshow('frame', stream.array)
				cv2.imwrite('/home/pi/Github/factory_control/cam.jpg', stream.array)
	   			p=subprocess.Popen(["zbarimg cam.jpg 2>/dev/null"],stdout=subprocess.PIPE,shell=True)
        			qr_code = p.stdout.read()
				if cv2.waitKey(1) & 0xFF == ord('q'):
        				break
        			# reset the stream before the next capture
        			stream.seek(0)
        			stream.truncate()
	    
			qr_result = qr_code[8:]
	
		#	print qr_result

			cv2.destroyAllWindows()
			return qr_result

def controller(user):
	if __name__ == '__main__':
		guiMain()			

	
def main():
	user_quit = 0
	

	initGPIO()
	sendString("BOOT")
	receivedString = receiveString()

	while (user_quit != 1):
		initGPIO()
	
		# user inputs a string, it is then converted to binary and sent to the DE2
		text = raw_input('Please enter your username: ') 
#		print text
	
		#send text to DE2
		sendString(text)
		
		# RECEIVE USER NAME AKNOWLEDGED FROM THE DE2
		receivedString = receiveString()
	
		#hardcode an accepted message for debug
	
		if receivedString == "Y":
			print "Welcome: " + text + ", please scan your ID badge "
			user_valid = 1
		else:
			print "Username: " + text + " was not valid"
			user_valid = 0
	
		if (user_valid == 1):
			result = scanQR()
			sendString(result)
			receivedString = receiveString()
			global user

			if receivedString == "Y":
				print "Login Accepted"
				user_login = 1
				
				if (text == "Phil"):
					user = 1
				elif(text == "Amro"):
					user = 2
				elif(text == "Steph"):
					user = 3
				elif(text == "John"):
					user = 4

			## START THE GUI INTERFACE ##
				controller(text)
			else:
				print "Id does not match Username"
				user_login = 0
				user = 0
	
		
	

main()

		
