"
I represent the Ar Drone current state (informed by Ar Drone firmware within navdata headers)
"
Class {
	#name : #ARDState,
	#superclass : #Object,
	#instVars : [
		'hexState'
	],
	#category : #ARDrone
}

{ #category : #accessing }
ARDState >> adcWatchdog [
	^ (hexState bitAt:30)
]

{ #category : #accessing }
ARDState >> altitudeControlAlgo [
	^ (hexState bitAt:5)
]

{ #category : #accessing }
ARDState >> angles [
	^ (hexState bitAt:20)
]

{ #category : #accessing }
ARDState >> aquisitionThread [
	^ (hexState bitAt:28)
]

{ #category : #converting }
ARDState >> asString [
	"returns drone's state as string "
	| message tab cr |
	tab := Character tab asString .
	cr := Character cr asString .
	message :=  
				tab, self flyMask  asString, ' : FLY MASK', cr,
				tab, self videoMask asString, ' : VIDEO MASK', cr,
				tab, self visionMask asString, ' : VISION MASK' , cr, 
				tab, self controlAlgo asString, ' : CONTROL ALGO' , cr,
				tab, self altitudeControlAlgo asString, ' : ALTITUDE CONTROL ALGO' , cr,
				tab, self userFeedback asString, ' : USER feedback' , cr,
				tab, self controlCommandAck asString, ' : Control command ACK' , cr,
				tab, self cameraEnable asString, ' : Camera enable' , cr,
				tab, self travelingEnable asString, ' : Travelling enable' , cr,
				tab, self usbKey asString, ' : USB key' , cr,
				tab, self navdataDemo asString, ' : Navdata demo' , cr,
				tab, self navdataBootstrap asString, ' : Navdata bootstrap' , cr,
				tab, self motorStatus asString, ' : Motors status' , cr,
				tab, self communicationLost asString, ' : Communication Lost' , cr,
				tab, self problemWithGyromometers asString, ' : Problem with gyrometers' , cr,
				tab, self vBatLow asString, ' : VBat low' , cr,
				tab, self userEmergencyLanding asString, ' : User Emergency Landing' , cr, 
				tab, self timerElapsed asString, ' : Timer elapsed' , cr,
				tab, self magnetometerCalibrationState asString, ' : Magnetometer calibration state' , cr,
				tab, self angles asString, ' : Angles' , cr,
				tab, self wind asString, ' : WIND MASK' , cr,
				tab, self ultrasonicSensor asString, ' : Ultrasonic sensor' , cr,
				tab, self cutoutSystemDetection asString, ' : Cutout system detection' , cr,
				tab, self picVersionNumberOk asString, ' : PIC Version number OK' , cr,
				tab, self atCodecThread asString, ' : ATCodec thread ON' , cr,
				tab, self navdataThread asString, ' : Navdata thread ON' , cr,
				tab, self videoThread asString, ' : Video thread ON' , cr,
				tab, self aquisitionThread asString, ' : Aquisition thread ON' , cr,
				tab, self ctrlWatchdog asString, ' : CTRL Watchdog' , cr,
				tab, self adcWatchdog asString, ' : ADC Watchdog' , cr,
				tab, self communicationWatchdog asString, ' : Communication Watchdog' , cr,
				tab, self emergencyLanding asString, ' : Emergency landing' , cr.
				
	^ message
]

{ #category : #converting }
ARDState >> asStringVerbose [
	"returns drone's state as string "
	| message tab cr |
	tab := Character tab asString .
	cr := Character cr asString .
	
	message := 'DRONE STATE :' ,cr , 
				tab, self flyMask  asString, ' : FLY MASK, (0) ardrone is landed, (1) ardrone is flying' , cr,
				tab, self videoMask asString, ' : VIDEO MASK, (0) video disable, (1) video enable' , cr,
				tab, self visionMask asString, ' : VISION MASK , (0) vision disable, (1) vision enable' , cr, 
				tab, self controlAlgo asString, ' : CONTROL ALGO, (0) euler angles control, (1) angular speed control' , cr,
				tab, self altitudeControlAlgo asString, ' : ALTITUDE CONTROL ALGO, (0) altitude control inactive (1) altitude control active' , cr,
				tab, self userFeedback asString, ' : USER feedback, Start button state' , cr,
				tab, self controlCommandAck asString, ' : Control command ACK, (0) None, (1) one received' , cr,
				tab, self cameraEnable asString, ' : Camera enable, (0) Camera enable, (1) camera disable' , cr,
				tab, self travelingEnable asString, ' : Travelling enable, (0) disable, (1) enable' , cr,
				tab, self usbKey asString, ' : USB key, (0) usb key not ready, (1) usb key ready' , cr,
				tab, self navdataDemo asString, ' : Navdata demo, (0) All navdata, (1) only navdata demo' , cr,
				tab, self navdataBootstrap asString, ' : Navdata bootstrap, (0) options sent in all or demo mode, (1) no navdata options sent' , cr,
				tab, self motorStatus asString, ' : Motors status, (0) Ok, (1) Motors Com is down' , cr,
				tab, self communicationLost asString, ' : Communication Lost, (1) com problem, (0) Com is ok' , cr,
				tab, self problemWithGyromometers asString, ' : Problem with gyrometers' , cr,
				tab, self vBatLow asString, ' : VBat low, (1) too low, (0) Ok' , cr,
				tab, self userEmergencyLanding asString, ' : User Emergency Landing, (1) User EL is ON, (0) User EL is OFF' , cr, 
				tab, self timerElapsed asString, ' : Timer elapsed, (1) elapsed, (0) not elapsed' , cr,
				tab, self magnetometerCalibrationState asString, ' : Magnetometer calibration state : (0) Ok, no calibration needed, (1) not ok, calibration needed' , cr,
				tab, self angles asString, ' : Angles, (0) Ok, (1) out of range' , cr,
				tab, self wind asString, ' : WIND MASK, (0) ok, (1) Too much wind' , cr,
				tab, self ultrasonicSensor asString, ' : Ultrasonic sensor, (0) Ok, (1) deaf' , cr,
				tab, self cutoutSystemDetection asString, ' : Cutout system detection, (0) Not detected, (1) detected' , cr,
				tab, self picVersionNumberOk asString, ' : PIC Version number OK, (0) a bad version number, (1) version number is OK' , cr,
				tab, self atCodecThread asString, ' : ATCodec thread ON, (0) thread OFF (1) thread ON' , cr,
				tab, self navdataThread asString, ' : Navdata thread ON, (0) thread OFF (1) thread ON' , cr,
				tab, self videoThread asString, ' : Video thread ON, (0) thread OFF (1) thread ON' , cr,
				tab, self aquisitionThread asString, ' : Aquisition thread ON, (0) thread OFF (1) thread ON' , cr,
				tab, self ctrlWatchdog asString, ' : CTRL Watchdog, (1) delay in control execution (> 5ms), (0) control is well scheduled // Check frequency of control loop' , cr,
				tab, self adcWatchdog asString, ' : ADC Watchdog, (1) delay in uart2 dsr (> 5ms), (0) uart2 is good // Check frequency of uart2 dsr (com with adc)' , cr,
				tab, self communicationWatchdog asString, ' : Communication Watchdog, (1) com problem, (0) Com is ok // Check if we have an active connection with a client' , cr,
				tab, self emergencyLanding asString, ' : Emergency landing, (0) no emergency, (1) emergency' , cr.
				
	^ message
]

{ #category : #accessing }
ARDState >> atCodecThread [
	^ (hexState bitAt:25)
]

{ #category : #accessing }
ARDState >> cameraEnable [
	^ (hexState bitAt:8)
]

{ #category : #accessing }
ARDState >> communicationLost [
	^ (hexState bitAt:14)
]

{ #category : #accessing }
ARDState >> communicationWatchdog [
	^ (hexState bitAt:31)
]

{ #category : #accessing }
ARDState >> controlAlgo [
	^ (hexState bitAt:4)
]

{ #category : #accessing }
ARDState >> controlCommandAck [
	^ (hexState bitAt:7)
]

{ #category : #accessing }
ARDState >> ctrlWatchdog [
	^ (hexState bitAt:29)
]

{ #category : #accessing }
ARDState >> cutoutSystemDetection [
	^ (hexState bitAt:23)
]

{ #category : #accessing }
ARDState >> emergencyLanding [
	^ (hexState bitAt:32)
]

{ #category : #accessing }
ARDState >> flyMask [
	^ (hexState bitAt:1)
]

{ #category : #accessing }
ARDState >> hexState [
	^ hexState
]

{ #category : #accessing }
ARDState >> hexState: anHex [
	hexState := anHex
]

{ #category : #accessing }
ARDState >> magnetometerCalibrationState [
	^ (hexState bitAt:19)
]

{ #category : #accessing }
ARDState >> motorStatus [
	^ (hexState bitAt:13)
]

{ #category : #accessing }
ARDState >> navdataBootstrap [
	^ (hexState bitAt:12)
]

{ #category : #accessing }
ARDState >> navdataDemo [
	^ (hexState bitAt:11)
]

{ #category : #accessing }
ARDState >> navdataThread [
	^ (hexState bitAt:26)
]

{ #category : #accessing }
ARDState >> picVersionNumberOk [
	^ (hexState bitAt:24)
]

{ #category : #accessing }
ARDState >> problemWithGyromometers [
	^ (hexState bitAt:15)
]

{ #category : #accessing }
ARDState >> timerElapsed [
	^ (hexState bitAt:18)
]

{ #category : #accessing }
ARDState >> travelingEnable [
	^ (hexState bitAt:9)
]

{ #category : #accessing }
ARDState >> ultrasonicSensor [
	^ (hexState bitAt:22)
]

{ #category : #updating }
ARDState >> updateFromHex: anHex [
	"updates this ARDState instance, based on the anHex value
	Drone state is stored as 32 bit hexadecimal value. Each bit indicates the state for a drone feature."
	^ self hexState: anHex 
]

{ #category : #accessing }
ARDState >> usbKey [
	^ (hexState bitAt:10)
]

{ #category : #accessing }
ARDState >> userEmergencyLanding [
	^ (hexState bitAt:17)
]

{ #category : #accessing }
ARDState >> userFeedback [
	^ (hexState bitAt:6)
]

{ #category : #accessing }
ARDState >> vBatLow [
	hexState ifNil: [^nil].
	^ (hexState bitAt:16)
]

{ #category : #accessing }
ARDState >> videoMask [
	^ (hexState bitAt:2)
]

{ #category : #accessing }
ARDState >> videoThread [
	^ (hexState bitAt:27)
]

{ #category : #accessing }
ARDState >> visionMask [
	^ (hexState bitAt:3)
]

{ #category : #accessing }
ARDState >> wind [
	^ (hexState bitAt:21)
]
