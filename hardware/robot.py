import paho.mqtt.client as mqtt
import time
import RPi.GPIO as GPIO
from drive import * 
from pdController import *
import smbus 
import pickle 
pdcont = PDController(0,1,1)
robot = Robot()
SONAR_MIN = 0   # SONAR_MIN = 20
SONAR_MAX = 0   # SONAR_MAX = 800
GPIO_TRIGGER = 23
GPIO_ECHO    = 24
UNIT_TRAVEL = 2 
WAIT = 0 
GO_TO = 1
UNLOCK = 2
DEMO = 3
row = 0
col = 0
x = 69
y = 0 
arrX = 13
arrY =0 
mapX = 0
mapY = 0
theta = 0
oldTime = 0
avail = [0, 0]
arr = pickle.load(open("map.pickle", "rb"))
state = WAIT
W = 0
N = 1 
E = 2 
S = 3 
servoPIN = 17
servoUpperPin = 22
GPIO.setup(servoUpperPin, GPIO.OUT)
GPIO.setup(servoPIN, GPIO.OUT)

p = GPIO.PWM(servoPIN, 50) # GPIO 17 for PWM with 50Hz
p2 = GPIO.PWM(servoUpperPin, 50)
p.start(2.5)
p2.start(2.5)


def sonar():
    # distance measurements in cm
    # set GPIO_TRIGGER to LOW
    GPIO.output(GPIO_TRIGGER, False)
    # let the sensor settle for a while
    #print "Waiting For Sensor To Settle"
    time.sleep(0.5)     # time.sleep(2)
    # send 10 microsecond pulse to GPIO_TRIGGER
    GPIO.output(GPIO_TRIGGER, True) # GPIO_TRIGGER -> HIGH
    time.sleep(0.00001) # wait 10 microseconds
    GPIO.output(GPIO_TRIGGER, False) # GPIO_TRIGGER -> LOW
    # create variable start and give it current time
    start = time.time()
    # refresh start value until GPIO_ECHO goes HIGH, so until the wave is send
    while GPIO.input(GPIO_ECHO)==0:
        start = time.time()
    # assign the actual time to stop variable until GPIO_ECHO goes back from HIGH to LOW
    while GPIO.input(GPIO_ECHO)==1:
        stop = time.time()
    # time it took the wave to travel there and back
    measuredTime = stop - start
    # calculate the travel distance by multiplying the measured time by speed of sound
    distanceBothWays = measuredTime * 33112 # cm/s in 20 degrees Celsius
    # divide the distance by 2 to get the actual distance from sensor to obstacle
    distance = distanceBothWays / 2
    return distance
def get_dist():
    global x
    global y
    global oldTime, arrX, arrY, theta
    
    delta = 0.333
    if (orr == N):
	    x = x + delta
	    arrX = arrX + delta
    elif (orr == E):
	    y = y - delta
	    arrY = arrY - delta
    elif (orr == S):
	    x = x - delta
	    arrX = arrX - delta
    else:
	    y = y + delta
	    arrY = arrY + delta 
    oldTime = time.time()
#def servo_lock(cubby):
#def servo_unlock(cubby):
def on_connect(client, userdata, flags, rc):
    print("Connected to server (i.e., broker) with result code "+str(rc))
    #subscribe to location topic
    client.subscribe("chargr/chargeme")
    client.message_callback_add("chargr/chargeme", on_loc)
def check_empty():
    if ((avail[0] == 0) and (avail[1] == 0)):
        return 0
    elif ((avail[0] == 0) or (avail[1] == 0)):
        return 1 
    else: 
        return 2
def on_loc(client, userdata, message):
    global state
    global oldTime
    print('Message' + message.payload.decode())
    loc_str = message.payload.decode()
    deli = 0
    rowS, colS = loc_str.split(",")
    row = int(rowS)
    col = int(colS)
    print(row, col)
    state = DEMO
    oldTime = time.time()
#
# open door function 
#
if __name__ == '__main__':
    #this section is covered in publisher_and_subscriber_example.py
    robot.halt()
    flag = 0
    p.ChangeDutyCycle(5.5)
    p2.ChangeDutyCycle(5.5)
    client = mqtt.Client()
    client.on_connect = on_connect
    client.connect(host="eclipse.usc.edu", port=11000, keepalive=60)
    client.loop_start()
    orr = W
    GPIO.setmode(GPIO.BCM)
    # set GPIO_TRIGGER to OUTPUT mode
    GPIO.setup(GPIO_TRIGGER,GPIO.OUT)
    # set GPIO_ECHO to INPUT mode
    GPIO.setup(GPIO_ECHO,GPIO.IN)
                    

    while True:
        distance = sonar()
        if (state == WAIT):
            robot.halt()
            cnt = 0
        elif (state == GO_TO):
            get_dist()
            if (distance < 11):
                robot.halt()
                robot.right_turn()
                robot.forward(0)
                time.sleep(0.5)
                robot.halt()
            else:
                if (arrX >= 5):
                    arrX = 0
                    mapX = mapX + 1 
                elif (arrX <= -5):
                    arrX = 0
                    mapX = mapX - 1
                if (arrY >= 5):
                    arrY = 0
                    mapY = mapY + 1
                elif (arrY <= -5):
                    arrY = 0 
                    mapY = mapY - 1  
                if (mapY != row):
                    if (row > mapY):
                        if (orr == N):
                            robot.left_turn()
                        if (orr == E):
                            robot.right_turn()
                            robot.right_turn()
                        if (orr == S):
                            robot.right_turn()
                        orr = W 
                    if (row < mapY): 
                        if (orr == N):
                            robot.right_turn()
                        if (orr == E):
                            robot.right_turn()
                            robot.right_turn()
                        if (orr == S):
                            robot.left_turn()
                        orr = E 
                    robot.forward(0)
                    print(mapX,mapY)
                    client.publish("chargr/loc", str(x/14) + ',' + str(y/11))
                elif (mapX != col):
                    if (col > mapX):
                        if (orr == W):
                            robot.right_turn()
                        if (orr == E):
                            robot.left_turn()
                        if (orr == S):
                            robot.right_turn()
                            robot.right_turn()
                        orr = N
                    if (col < mapX): 
                        if (orr == W):
                            robot.left_turn()
                        if (orr == E):
                            robot.right_turn()
                        if (orr == S):
                            robot.right_turn()
                            robot.right_turn()
                        orr = S 
                    robot.forward(0)
                    print(mapX,mapY)
                    client.publish("chargr/loc", str(x/14) + ',' + str(y/11))
                else: 
                    robot.halt()
                    p.ChangeDutyCycle(12)
                    time.sleep(20)
                    p.ChangeDutyCycle(5.5)
                    p2.ChangeDutyCycle(12)
                    time.sleep(20)
                    p2.ChangeDutyCycle(5.5)
                    state = WAIT

        elif (state == DEMO):
            robot.forward(0)
            if (flag == 0):
                cnt = cnt+1
                client.publish("chargr/loc", str(0) + ',' + str(cnt*0.5))
            else: 
                cnt = cnt - 1 
            if (cnt == 9):
                robot.right_turn()
                robot.right_turn()
                flag = 1
                cnt = cnt-1
            elif (cnt == 0):
                robot.halt()
                p.ChangeDutyCycle(12)
                time.sleep(5)
                p.ChangeDutyCycle(5.5)
                p2.ChangeDutyCycle(12)
                time.sleep(5)
                p2.ChangeDutyCycle(5.5)
                state = WAIT

        print(state)
        time.sleep(0.5)