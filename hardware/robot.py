import paho.mqtt.client as mqtt
import time
import RPi.GPIO as GPIO
from drive import * 
from pdController import *
import smbus 
import pickle 

pdcont = PDController(0,1,1)
robot = Robot()


UNIT_TRAVEL = 2 
WAIT = 0 
GO_TO = 1
UNLOCK = 2
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

def get_dist():
    global x
    global y
    global oldTime, arrX, arrY, theta
    
    delta = 0.4 *(time.time()-oldTime)
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

    theta = ((x**2 + y**2)**(1/2))/.1
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
    loc_str = str(message.payload).encode("utf-8")
    deli = 0
    for i in loc_str:
        if (loc_str[i] == ","):
            deli = i 
    row = int(loc_str[0:deli])
    col = int(loc_str[deli+1])

    if (check_empty()==0):
        state = GO_TO

#
# open door function 
#
if __name__ == '__main__':
    #this section is covered in publisher_and_subscriber_example.py
    halt()
    client = mqtt.Client()
    client.on_connect = on_connect
    client.connect(host="eclipse.usc.edu", port=11000, keepalive=60)
    client.loop_start()
    row = 1
    col = 3
    orr = W
    state = GO_TO

    while True:

        if (state == WAIT):
            robot.halt()
        elif (state == GO_TO):
            get_dist()
            if (arrX >= 1.5):
                arrX = 0
                mapX = mapX +1 
            elif (arrX <= -1.5):
                arrX = 0
                mapX = mapX - 1

            if (arrY >= 1):
                arrY = 0
                mapY = mapY + 1
            elif (arrY <= -1):
                arrY = 0 
                mapY = mapY - 1  

            if (arrY != row):
                if (row > arrY):
                    if (orr == N):
                       robot.left_turn()
                    if (orr == E):
                        robot.right_turn()
                        robot.right_turn()
                    if (orr == S):
                        robot.right_turn()
                    orr = W 
                if (row < arrY): 
                    if (orr == N):
                        robot.right_turn()
                    if (orr == E):
                        robot.right_turn()
                        robot.right_turn()
                    if (orr == S):
                        robot.left_turn()
                    orr = E 
            elif (arrX != col):
                if (col > arrX):
                    if (orr == W):
                        robot.right_turn()
                    if (orr == E):
                        robot.left_turn()
                    if (orr == S):
                        robot.right_turn()
                        robot.right_turn()
                    orr = N
                if (col < arrX): 
                    if (orr == W):
                        robot.left_turn()
                    if (orr == E):
                        robot.right_turn()
                    if (orr == S):
                        robot.right_turn()
                        robot.right_turn()
                    orr = S 
                robot.forward(pdcont.update(0))
                print(theta)
                client.publish("chargr/loc", str(int(x/14)) + ',' + str(int(y/11)))
            else: 
                halt()
                state = WAIT