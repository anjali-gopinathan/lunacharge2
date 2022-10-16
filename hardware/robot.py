import paho.mqtt.client as mqtt
import time
import RPi.GPIO as GPIO
import drive 
from mfrc522 import SimpleMFRC522

UNIT_TRAVEL = 2 
WAIT = 0 
GO_TO = 1
UNLOCK = 2

def init():   
    arr = pickle.load(open("map.pickle", "rb"))
    robo_init()
    state = WAIT
    reader = SimpleMFRC522()
    x = 0
    y = 0 
#
# 

#
# open door function 
#
if __name__ == '__main__':
    #this section is covered in publisher_and_subscriber_example.py
    client = mqtt.Client()
    client.on_message= on_message
    client.on_connect = on_connect
    client.connect(host="eclipse.usc.edu", port=11000, keepalive=60)
    client.loop_start()

    while True:
        if (state == WAIT):
            reader.