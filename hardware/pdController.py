import time 

class PDController:
    def __init__(self, target, kp, kd):
        self.target = target 
        self.kp = kp
        self.kd = kd 
        self.oldError = 0
        self.oldTime = time.time()

    def update(self,value):
        err = value - self.target
        newTime = time.time()
        o = err*self.kp + (err-self.oldError)/(newTime-self.oldTime)*self.kd
        oldTime = newTime
        return o 