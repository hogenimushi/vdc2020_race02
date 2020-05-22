# """ 
# My CAR CONFIG 

# This file is read by your car application's manage.py script to change the car
# performance

# If desired, all config overrides can be specified here. 
# The update operation will not touch this file.
# """

DRIVE_LOOP_HZ = 20
SEQUENCE_LENGTH = 2

JOYSTICK_MAX_THROTTLE = 1.0
JOYSTICK_STEERING_SCALE = 1.0

DONKEY_GYM = True

DONKEY_SIM_PATH = "./DonkeySimLinux/donkey_sim.x86_64" 
#DONKEY_SIM_PATH = "remote" 
DONKEY_GYM_ENV_NAME = "donkey-mountain-track-v0" 
GYM_CONF = { "body_style" : "donkey", "body_rgb" : (92, 92, 240), "car_name" : "Hogenimushi", "font_size" : 18} # body style(donkey|bare|car01) body rgb 0-255

SIM_HOST = "localhost"
SIM_ARTIFICIAL_LATENCY = 0

WEB_CONTROL_PORT = 8887 
WEB_INIT_MODE = "local"   # or user

# for learning
MAX_EPOCHS = 150
EARLY_STOP_PATIENCE = 20
CACHE_IMAGES = False

CONTROLLER_TYPE='F710'
