#!/usr/bin/env python

import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

reader = SimpleMFRC522()
valid_ids = []

try: 
        valid_ids = pickle.load(open("rfid.pickle", "rb"))
try:
        id, text = reader.read()
        print(id)
        print(text)
        valid_ids.append(id)
finally:
        pickle.dump(notes, open("rfids.pickle", "wb"))
        GPIO.cleanup()

