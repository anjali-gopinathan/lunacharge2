import time 

class PDController:
    def __init__(self, target, kp, kd):
        self.target = target 
        self.kp = kp
        self.kd = kd 
        self.oldError = 0
        self.oldTime = time.time()

    def update(self,value):
        err = value - target
        newTime = time.time()
        o = err*kp + (err-oldError)/(newTime-oldTime)*kd
        oldTime = newTime
        return o 