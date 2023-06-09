import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO.setup(23, GPIO.IN) #PIR


try:
    time.sleep(2) # to stabilize sensor
    while True:
        if GPIO.input(23):
            time.sleep(0.5) #Buzzer turns on for 0.5 sec
            print("Motion Detected...")
            time.sleep(0) #to avoid multiple detection
	elif GPIO.input(23)==0:
	    time.sleep(0.5)
	    print('No motion')
	    time.sleep(0)
        time.sleep(0.1) #loop delay, should be less than detection delay

except:
    GPIO.cleanup()
