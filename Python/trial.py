import subprocess
import cv2

def trial():
    """Detects qr code from camera and returns string that represents that code.

    return -- qr code from image as string
    """
    #subprocess.call(["raspistill -w 640 -h 480 -n -t 1 -q 10 -e jpg -th none -o cam.jpg"],shell=True)  
    #p=subprocess.Popen(["zbarimg cam.jpg"],stdout=subprocess.PIPE,shell=True)
    #img=cv2.imread('/home/pi/project/cam.jpg')
    #cv2.imshow('ImageWindow',img)
    #cv2.waitKey()
    #subprocess.call(["sudo fbi -d /dev/fb0 -a -T 2 cam.jpg"],shell=True)
    #subprocess.call(["sudo fbi -d /dev/fb0 -a -T 2 cam.jpg"],shell=True)
    #qr_code = p.stdout.read()

    while True:
	subprocess.call(["raspistill -w 640 -h 480 -n -t 1 -q 10 -e jpg -th none -o cam.jpg"],shell=True)
	#p=subprocess.Popen(["zbarimg cam.jpg"],stdout=subprocess.PIPE,shell=True)
	#subprocess.call(["sudo fbi -d /dev/fb0 -a -T 2 cam.jpg"],shell=True)
	img = cv2.imread('/home/pi/project/cam.jpg')
        cv2.imshow('ImageWindow',img)
        cv2.waitKey(1)
        #qr_code = p.stdout.read()
    # out looks like "QR-code: Xuz213asdY" so you need
    # to remove first 8 characters plus whitespaces
    #if len(out) > 7:
        #qr_code = out[8:].strip()
    
    #print qr_code
    #return qr_code
trial()
