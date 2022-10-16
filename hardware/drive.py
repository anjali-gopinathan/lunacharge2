from gpiozero import PWMOutputDevice
import time

LEFT_FORWARD = 26 #IN1
LEFT_REVERSE = 19 #IN2
RIGHT_FORWARD = 13
RIGHT_REVERSE = 6

class Robot:
    def __init__(self):
        self.forwardLeft = PWMOutputDevice(LEFT_FORWARD, True, 0, 1000)
        self.reverseLeft = PWMOutputDevice(LEFT_REVERSE, True, 0, 1000)  
        self.forwardRight = PWMOutputDevice(RIGHT_FORWARD, True, 0, 1000)
        self.reverseRight = PWMOutputDevice(RIGHT_REVERSE, True, 0, 1000)   

    def forward(self,o):
        self.forwardLeft.value = 1.0*(1+o)
        self.reverseLeft.value = 0
        self.forwardRight.value = 1.0*(1-o)
        self.reverseRight.value = 0

    def left_turn(self):
        self.halt()
        self.forwardLeft.value = 0.0
        self.reverseLeft.value = 1.0
        self.forwardRight.value = 1.0
        self.reverseRight.value = 0
        time.sleep(1)
        self.halt()

    def right_turn(self):
        self.halt()
        self.forwardLeft.value = 1.0
        self.reverseLeft.value = 0
        self.forwardRight.value = 0
        self.reverseRight.value = 1.0
        time.sleep(1)
        self.halt()

    def halt(self):
        self.forwardLeft.value = 0
        self.reverseLeft.value = 0
        self.forwardRight.value = 0
        self.reverseRight.value = 0

