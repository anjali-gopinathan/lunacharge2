import paho.mqtt.client as mqtt
import time
import RPi.GPIO as GPIO
from drive import * 
from pdController import *
import smbus 

from imusensor.MPU9250 import MPU9250

address = 0x68
bus = smbus.SMBus(1)
mpu9250 = MPU9250.MPU9250(bus, address) 
PDController pdcont(0,1,1)

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
    mpu9250.resdSensor()
    mpu9250.computeOrientation()
    gY = mpu9250.GyroVals[1]
    gX = mpu9250.GyroVals[0]
    gZ = mpu9250.GyroVals[2]
    x = x + gX*(time.time()-oldTime)
    y = y + gY*(time.time()-oldTime)
    arrX = arrX + gX*(time.time()-oldTime)
    arrY = arrY + gY*(time.time()-oldTime)
    theta = theta + gZ(time.time()-oldTime)
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
    client.on_message= on_message
    client.on_connect = on_connect
    client.connect(host="eclipse.usc.edu", port=11000, keepalive=60)
    client.loop_start()
    row = 1
    col = 3
    orr = W 

    while True:

        if (state == WAIT):
            halt()
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
                        left_turn()
                    if (orr == E):
                        right_turn()
                        right_turn()
                    if (orr == S):
                        right_turn()
                    orr = W 
                if (row < arrY): 
                    if (orr == N):
                        right_turn()
                    if (orr == E):
                        right_turn()
                        right_turn()
                    if (orr == S):
                        left_turn()
                    orr = E 
            elif (arrX != col):
                if (col > arrX):
                    if (orr == W):
                        right_turn()
                    if (orr == E):
                        left_turn()
                    if (orr == S):
                        right_turn()
                        right_turn()
                    orr = N
                if (col < arrX): 
                    if (orr == W):
                        left_turn()
                    if (orr == E):
                        right_turn()
                    if (orr == S):
                        right_turn()
                        right_turn()
                    orr = S 
                forward(pdcont.update(theta)):
                client.publish("chargr/loc", str(int(x/14)) + ',' + str(int(y/11)))
            else: 
                halt()
                state = WAIT    


