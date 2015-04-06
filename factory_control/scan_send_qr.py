import cv2
import picamera
import picamera.array
import subprocess
import RPi.GPIO as GPIO
from time import sleep

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

	
# purpose of program is to toggle leds on the DE2 by sending bytes of data and communicating with DE2 through handshaking protocol
# Set up GPIO

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

#GPIO.output(dataPins, True)
#GPIO.output(valid, True)
#GPIO.output(doneTransmit, True)

# user inputs a string, it is then converted to binary and sent to the DE2
text = qr_result
#text = raw_input('enter some text: ') 
print text
# print the binary value of the characters in the string
	
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
#	sleep(5)
	while GPIO.input(ackPin) == False:
		#do nothing until DE2 tells us the message was received
		GPIO.output(valid, True)
	GPIO.output(valid, False)
	GPIO.output(dataPins, False)

print('Done transmit')
GPIO.output(doneTransmit, True)
sleep (4)
GPIO.output(doneTransmit, False)
GPIO.output(valid, False)
#GPIO.cleanup()
