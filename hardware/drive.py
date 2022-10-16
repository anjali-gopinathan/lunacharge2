from gpiozero import PWMOutputDevice
import time

LEFT_FORWARD = 26 #IN1
LEFT_REVERSE = 19 #IN2
RIGHT_FORWARD = 13
RIGHT_REVERSE = 6

def robo_init():
    forwardLeft = PWMOutputDevice(LEFT_FORWARD, True, 0, 1000)
    reverseLeft = PWMOutputDevice(LEFT_REVERSE, True, 0, 1000)  
    forwardRight = PWMOutputDevice(RIGHT_FORWARD, True, 0, 1000)
    reverseRight = PWMOutputDevice(RIGHT_REVERSE, True, 0, 1000)   

def forward(o):
    forwardLeft.value = 1.0*(1+o)
    reverseLeft.value = 0
    forwardRight.value = 1.0*(1-o)
    reverseRight.value = 0

def left_turn():
    halt()
    forwardLeft.value = 0.0
    reverseLeft.value = 1.0
    forwardRight.value = 1.0
    reverseRight.value = 0
    time.sleep(1)
    halt()

def right_turn():
    halt()
    forwardLeft.value = 1.0
    reverseLeft.value = 0
    forwardRight.value = 0
    reverseRight.value = 1.0
    time.sleep(1)
    halt()

def halt():
    forwardLeft.value = 0
    reverseLeft.value = 0
    forwardRight.value = 0
    reverseRight.value = 0

    
