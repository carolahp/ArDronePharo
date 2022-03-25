"
I'm the main class of the package. I provide a public API for communicating with the Parrot AR.Drone 2.0.
"
Class {
	#name : #ARDrone,
	#superclass : #Object,
	#instVars : [
		'navdataManager',
		'navdataAdapter',
		'commandManager',
		'commandAdapter',
		'configurationManager',
		'connectionManager',
		'authAdapter',
		'sequenceNumber',
		'mutex',
		'announcer',
		'motionState',
		'exceptionHandlers',
		'currentVideoChannel',
		'visionDetectAnalyst'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #ARDrone
}

{ #category : #'as yet unclassified' }
ARDrone class >> CRC32From: aString [
	^ (((CRC crc32FromCollection: aString asString) hex asString substrings: 'r') at:2) asLowercase 
]

{ #category : #'instance creation' }
ARDrone class >> new [
	
	self error: 'Should use ARDrone singleton'
]

{ #category : #'instance creation' }
ARDrone class >> newUniqueInstance [
	uniqueInstance ifNotNil: [ uniqueInstance destroyExceptionHandlers ].
	uniqueInstance := self basicNew.
	uniqueInstance 	announcer subscriptions reset.

	^ uniqueInstance
]

{ #category : #'instance creation' }
ARDrone class >> uniqueInstance [
	
	uniqueInstance ifNil: [ uniqueInstance := self basicNew ].
	uniqueInstance destroyExceptionHandlers.
	uniqueInstance 	announcer subscriptions reset.
	^ uniqueInstance.
]

{ #category : #'public api' }
ARDrone >> addHandlerFor: anExceptionClass do: aBlock [
	"Adds a handler for a specific exception. This handler is specially designed for drone exceptions. 
	Arguments:
		- anExceptionClass: the exception as a class
		- aBlock: a block of code, it must receive the exception as argument.
	Example: 
		self addHandlerFor: DroneConnectionInterrupted do: [ :ex | Transcript show: 'connection interrumpted!';cr ]"
		
	self exceptionHandlers at: anExceptionClass name asSymbol put: aBlock.

]

{ #category : #'public api-state' }
ARDrone >> altitude [
	"return the current altitude (as an int in centimeters)"
	self connectionState ~= ARDConstant connection_CONNECTED ifTrue: [ ^ nil ]. 
	^ self navdataManager lastDatagramReceived droneAltitude.
]

{ #category : #'public api' }
ARDrone >> animateFlight: aFlightAnimationNumber duration: aDuration [
	"Animates the drone LEDs. Arguments:
	- LedAnimation - [ Integer ] Enumeration, its values are defined in the ARDCommand class side.
	- Duration - [ milliseconds ]"
	
	commandManager 
		animateFlight: aFlightAnimationNumber 
		duration: aDuration 

	
]

{ #category : #'public api' }
ARDrone >> animateLEDs: aLEDAnimationNumber frequency: aFrequency duration: aDuration [
	"Animates the drone LEDs. Arguments:
	- LedAnimation - [ Integer ] Enumeration, its values are defined in the ARDCommand class side.
	- Frequency - [ Hertz ]
	- Duration - [ seconds ]"
	
	commandManager 
		animateLEDs: aLEDAnimationNumber 
		frequency: aFrequency 
		duration: aDuration 

	
]

{ #category : #accessing }
ARDrone >> announcer [
	"Returns an announcer for announcing drone's state changes"
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'accessing-adapters' }
ARDrone >> authAdapter [
	"Returns the ARDAdapterUDP used for authenticate to the drone"
	^ authAdapter
]

{ #category : #constants }
ARDrone >> authTimeout [
	"Returns the timeout for trying to authenticate to the drone's firmware."
	^ 5 second
]

{ #category : #'public api-state' }
ARDrone >> batteryLevel [
	"returns the remaining battery percentage as an integer"
	self connectionState ~= ARDConstant connection_CONNECTED ifTrue: [ ^ nil ].
	^ self navdataManager lastDatagramReceived droneBatteryLevel. 
]

{ #category : #'public api-video' }
ARDrone >> changeVideoChannel [

	currentVideoChannel :=
		(currentVideoChannel isNil) 
		ifTrue: [ ARDConstant videoChannel_ZAP_CHANNEL_VERT ]
		ifFalse: [ (currentVideoChannel asInteger+ 1) % 2 ] .
	self commandManager configVideoChannel: currentVideoChannel. 
]

{ #category : #'accessing-adapters' }
ARDrone >> commandAdapter [
	"Returns the ARDBridge used for sending AT commands"
	^ commandAdapter
]

{ #category : #'accessing-managers' }
ARDrone >> commandManager [
	"Returns the ARDCommandManager used for managing AT commands"
	^ commandManager.
]

{ #category : #'public api-config' }
ARDrone >> configFlightWithoutShell [
	"Returns the configurated value inside the drone for the control:flight_without_shell variable, it can be true of false"
	^ self configurationManager valueForParameter: 'control:flight_without_shell' .

]

{ #category : #'public api-config' }
ARDrone >> configFlightWithoutShell: aBoolean [
	"Tells the drone firmware wether the drone is using the outdoor hull or not. Set to false if the drone is using the indoor hull. 
	Argument: 
	- aBoolean: True for outdoor hull, False for indoor hull."
	self commandManager configFlightWithoutShell: aBoolean.

]

{ #category : #'public api-config' }
ARDrone >> configFlyingMode [

	^ self configurationManager valueForParameter: 'control:flying_mode' .

]

{ #category : #'public api-config' }
ARDrone >> configFlyingMode: aFlyingMode [

	self commandManager configFlyingMode: aFlyingMode.

]

{ #category : #'public api-config' }
ARDrone >> configFlyingModeFreeFlight [
	
	self commandManager configDetectionsDefault.
	self commandManager configFlyingMode: ARDConstant flyingMode_FREE_FLIGHT.
	 
	 
]

{ #category : #'public api-config' }
ARDrone >> configFlyingModeHoverOnTopOfOrientedRoundel [
	
	self commandManager configDetectType: ARDConstant detectType_ORIENTED_COCARDE_BW.
	self commandManager configFlyingMode: ARDConstant flyingMode_HOVER_ON_TOP_OF_ORIENTED_ROUNDEL.
]

{ #category : #'public api-config' }
ARDrone >> configOutdoor [
	"Returns the configurated value inside the drone for the control: outdoor variable, it can be true of false"
	^ self configurationManager valueForParameter: 'control:outdoor' .

]

{ #category : #'public api-config' }
ARDrone >> configOutdoor: aBoolean [
	"Tells the drone firmware if the drone is flying outdoors. (Changes the max velocity and tilts, and enabled the wind estimator)
	Argument: 
	- aBoolean: True for outdoors, False for indoors."
	self commandManager configOutdoor: aBoolean.

]

{ #category : #'public api-config' }
ARDrone >> configReconnectTimeout: anInt [
	"Maximum time (in seconds) for trying to reconnect before signaling the DroneConnectionTimeout exception. If no automatic reconnection mechanism is needed, set this value to 0. (Default value is 5)"
	self connectionManager reconnectTimeout: anInt
]

{ #category : #'public api-video' }
ARDrone >> configVideoChannel [
	"Returns the configurated value inside the drone for the video:video_channel variable, it can be 0 or 1"
	^ self configurationManager valueForParameter: 'video:video_channel' .
]

{ #category : #'public api-video' }
ARDrone >> configVideoChannel: anInt [
	currentVideoChannel := anInt.
	self commandManager configVideoChannel: anInt 
]

{ #category : #'accessing-managers' }
ARDrone >> configurationManager [
	"Returns the ARDConfigurationManager used for receiving the drone's configuration"
	^ configurationManager.
]

{ #category : #'accessing-managers' }
ARDrone >> connectionManager [	
	^ connectionManager
]

{ #category : #'public api-state' }
ARDrone >> connectionState [
	
	^ self connectionManager connectionState
]

{ #category : #'private ' }
ARDrone >> destroyExceptionHandlers [
	exceptionHandlers := nil.
]

{ #category : #'public api-config' }
ARDrone >> droneConfigurationFor: aParameter [
	"Argument:
	- aString -> is the parameter name as String (ie: 'general:num_version_config')"
	^ self configurationManager valueForParameter: aParameter.
	
]

{ #category : #'public api-config' }
ARDrone >> droneSetConfigurationFor: aParameter value: aVal [
	"Argument:
	- aParameter -> is the parameter name as String (ie: 'control:hovering_range')
	- aVal -> the value for that parameter as String (ie: '1000')"
	^ self commandManager setConfigFor: aParameter value: aVal.
	
]

{ #category : #'public api-move' }
ARDrone >> elevate: verticalSpeed [
	"Makes the drone elevate or descend according to the velocity specified by verticalSpeed.
	The drone will keep elevating or descending at verticalSpeed velocity until its verticalSpeed is set again by this function or by moveByLeftRightTilt:frontBackTilt:angularSpeed:verticalSpeed:
	Argument:
	- verticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending."

	self motionState 
		verticalSpeed: verticalSpeed.
]

{ #category : #'public api-move' }
ARDrone >> elevateTo: anAltitude atSpeed: aSpeed [
	"elevates (ascend or descend) the drone, to the desired altitude (confirmed via navdata).
	Argument: 
		- anAltitude: Integer representing the desired altitude in centimeters
		- aSpeed: Float in [0, 1] representing a percentage of the max elevation velocity configured for the drone"
	self commandManager elevateTo: anAltitude atSpeed: aSpeed 
]

{ #category : #'private ' }
ARDrone >> excecuteHandlerFor: anException [

	^ (self exceptionHandlers 
					at: anException className asSymbol 
					ifAbsent: [ anException defaultAction ] ) value: anException.
]

{ #category : #'private ' }
ARDrone >> exceptionHandlers [
	"Returns a dictionary of exception handlers, that can be used by the user to replace an exception's the default action with a custom block of code"
	^ exceptionHandlers ifNil: [ exceptionHandlers := Dictionary new. ]
]

{ #category : #'public api-state' }
ARDrone >> hasReceivedNavdata [

	^ self navdataManager hasReceivedNavdata
]

{ #category : #'private ' }
ARDrone >> initializeAdapters [
	"Initializes adapters for sending and receiving messages."
	navdataAdapter := ARDAdapterUDP withARDrone: self
											port: ARDConstant port_NAVDATA 
											isMulticast: true
											delayInterval: 30.
	commandAdapter := ARDAdapterUDP withARDrone: self
											port: ARDConstant port_COMMAND  
											isMulticast: false
											delayInterval: 30.
	authAdapter := ARDAdapterUDP withARDrone: self
										port: ARDConstant port_AUTH 
										isMulticast: false
										delayInterval: 30.

]

{ #category : #'private ' }
ARDrone >> initializeManagers [
	"First initializes the connection manager"
	connectionManager := ARDConnectionManager withARDrone: self.
	"Initializes the managers for receiving navdata, sending AT commands and announcing changes in the drone's state"
	navdataManager := ARDNavdataManager withARDrone: self.
	commandManager := ARDCommandManager withARDrone: self.
	configurationManager := ARDConfigurationManager withARDrone: self.
	visionDetectAnalyst := ARDVisionDetectAnalyst withARDrone: self.
	
	motionState := ARDMotionState new.
	connectionManager startWatchdog.

	^ true.
	
	
]

{ #category : #'public api-state' }
ARDrone >> isConnected [
	^ self connectionManager isNotNil and: [ self connectionState = ARDConstant connection_CONNECTED ]. 
]

{ #category : #'public api-state' }
ARDrone >> isFlying [
	"returns true if the drone is flying, false if it's landed"
	^ self navdataManager lastDatagramReceived droneIsFlying.
]

{ #category : #'public api-state' }
ARDrone >> isInEmergencyState [
	"returns true if the drone is in emergency state"
	self connectionState ~= ARDConstant connection_CONNECTED ifTrue: [ ^ nil ].
	^ self navdataManager lastDatagramReceived droneIsInEmergencyState. 
]

{ #category : #'public api-move' }
ARDrone >> land [
	"Lands the drone"
	commandManager land.
]

{ #category : #'public api-state' }
ARDrone >> lastNavdataPacketReceived [
	^ self navdataManager lastDatagramReceived
]

{ #category : #'public api-state' }
ARDrone >> lowBattery [

	self connectionState ~= ARDConstant connection_CONNECTED ifTrue: [ ^ nil ].
 	^ self navdataManager lastDatagramReceived droneLowBattery. 
]

{ #category : #accessing }
ARDrone >> motionState [
	"Returns the ARDMotionState used for saving the arDrone's motion state set by the UI controller"
	^ motionState
]

{ #category : #'public api-move' }
ARDrone >> moveByLeftRightTilt: leftRightTilt frontBackTilt: frontBackTilt angularSpeed: angularSpeed verticalSpeed: verticalSpeed [
	"Moves the drone according to the tilts and velocities recieved as argumentslrTilt.
	
	Arguments:
	- leftRightTilt (roll or phi angle) 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 									 			- (-) for left, (+) for right.
	- frontBackTilt (pitch or theta angle) 
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 
			- (-) for front (drone lowers its nose), (+) for back (drone raise its nose)
	- verticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending.
	- angularSpeed (yaw)
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left."
	self motionState 
		leftRightTilt: leftRightTilt;
		frontBackTilt: frontBackTilt;
		angularSpeed: angularSpeed;
		verticalSpeed: verticalSpeed.
]

{ #category : #'public api-move' }
ARDrone >> moveFor: aDuration atSpeed: aSpeed withDirection: anAngle [
	"Moves the drone progressivelly for aTimeInterval time, with maximum speed aSpeed, in the direction indicated by anAngle.
	Argument: 
		- aDuration: Integer, in milli seconds
		- aSpeed: Float in [0, 1] representing a percentage of the max roll and pitch velocity configured for the drone
		- anAngle: Integer in [ 0, 360 ], represents the direction in wich the drone will move. Looking the drone from above, the zero is in the drone's nose, and increments clockwise."
	self commandManager moveFor: aDuration atSpeed: aSpeed withDirection: anAngle.
]

{ #category : #accessing }
ARDrone >> mutex [
	
	^ mutex ifNil: [ mutex := Mutex new ].
]

{ #category : #'accessing-adapters' }
ARDrone >> navdataAdapter [
	"Returns the ARDBridge used for receiving navdata"
	^ navdataAdapter
]

{ #category : #'accessing-managers' }
ARDrone >> navdataManager [
	
	^ navdataManager.
]

{ #category : #'public api' }
ARDrone >> nextSequenceNumber [
	"Returns the sequence number for the next AT command datagram "
	sequenceNumber := self sequenceNumber + 1.
	^ self sequenceNumber 
]

{ #category : #'public api-move' }
ARDrone >> pitch: frontBackTilt [
	"Makes the drone pitch the amount specified by frontBackTilt.
	The drone will mantain the frontBackTilt inclination until it is set again by this function or by moveByLeftRightTilt:frontBackTilt:angularSpeed:verticalSpeed:
	Argument:
	- frontBackTilt (pitch or theta angle)  	
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 									 			
			- (-) for left, (+) for right."
	self motionState 
		frontBackTilt: frontBackTilt.
]

{ #category : #'private ' }
ARDrone >> resetManagers [
	self terminateManagers.
	^ self initializeManagers.
]

{ #category : #'private ' }
ARDrone >> resetSequenceNumber [
	sequenceNumber := 0
]

{ #category : #'public api-config' }
ARDrone >> retreiveConfigurationFromDrone [
	self configurationManager retrieveConfigurationFile.
	
]

{ #category : #'public api-move' }
ARDrone >> roll: leftRightTilt [
	"Makes the drone roll the amount specified by leftRightTilt.
	The drone will mantain the leftRightTilt inclination until it is set again by this function or by moveByLeftRightTilt:frontBackTilt:angularSpeed:verticalSpeed:
	Arguments:
	- leftRightTilt (roll or phi angle) 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 									 			
			- (-) for left, (+) for right."
	self motionState 
		leftRightTilt: leftRightTilt.
]

{ #category : #'public api' }
ARDrone >> sequenceNumber [

	^ sequenceNumber ifNil: [ ^ 1 ]
]

{ #category : #'public api' }
ARDrone >> setDefaultHandlers [

	self addHandlerFor: DroneConnectionTimeout 
		do: [ :ex | Transcript show: 'Timeout';cr].
	
	self addHandlerFor: DroneConnectionInterrupted 
		do: [ :ex | Transcript show: 'Connection interrupted';cr. ].
	
]

{ #category : #'public api' }
ARDrone >> setNavdataReceiverCallback: aBlock [
	"Redefines the Navdata receiverProcess, so now in each cycle it receives one datagram and excecutes aBlock using the datagram as argument. 
	Arguments:
	- aBlock <Block> Must receive the datagram as argument"
	navdataManager receiverProcessCallback: aBlock
	
]

{ #category : #'public api' }
ARDrone >> signalAndHandle: anExceptionClass [
	[ anExceptionClass signal ]
	on: anExceptionClass 
	do: [ :ex | self excecuteHandlerFor: ex  ] .
]

{ #category : #'public api-move' }
ARDrone >> stabilize [
	"Sets all drone tilts, vertical and angular velocity to zero"
	self moveByLeftRightTilt: 0 frontBackTilt: 0 angularSpeed: 0 verticalSpeed: 0
]

{ #category : #'public api' }
ARDrone >> startSession [
	"initializes all processes related to the arDrone uniqueInstance and sets up the connection"

	Transcript show: 'Starting arDrone session';cr.

	self initializeAdapters .
	( self resetManagers ) ifFalse: [ Transcript show: 'Couldnt start managers';cr. ^ false ].

	self mutex critical: [ self resetSequenceNumber ].
	
	
	"Delay for allowing the reception of some navdata packages"
	(Delay forMilliseconds: 100).
	^ true
	
]

{ #category : #'public api-init' }
ARDrone >> startSessionWithHandlers [

	self setDefaultHandlers.
	self startSession.
]

{ #category : #'private ' }
ARDrone >> state [
	"Returns the state of the drone, based on the last navigation datagram received"
	self navdataManager lastDatagramReceived ifNil:[ ^ nil ].
	^ self navdataManager lastDatagramReceived header state.
]

{ #category : #'public api-tags detection' }
ARDrone >> tagDetected: aDetectedTagType [
	^ self visionDetectAnalyst detectedTag: aDetectedTagType 
]

{ #category : #'public api-tags detection' }
ARDrone >> tagsTotalDetected [
	^ self visionDetectAnalyst nTagsDetected 
]

{ #category : #'public api-move' }
ARDrone >> takeOff [
	"Takes off the drone"
	commandManager takeOff.
]

{ #category : #'private ' }
ARDrone >> terminateAdapters [
	self navdataAdapter ifNotNil: [ self navdataAdapter closeAndDestroy ].
	self commandAdapter ifNotNil: [ self commandAdapter closeAndDestroy ].
	
	
]

{ #category : #'private ' }
ARDrone >> terminateManagers [
	"Terminates all manager's processes related to the this ARDrone's instance"
	connectionManager ifNotNil: [ connectionManager terminate ].
	navdataManager ifNotNil: [ navdataManager terminate ].
	commandManager ifNotNil: [ commandManager terminate ].
	configurationManager ifNotNil: [ configurationManager terminate ].
	 visionDetectAnalyst ifNotNil: [ visionDetectAnalyst destroy ] .
]

{ #category : #'public api' }
ARDrone >> terminateSession [
	"Terminates all procecesses used by this arDrone session"
	Transcript show: 'Terminating arDrone session';cr.
	self terminateManagers.
	self terminateAdapters.
	
]

{ #category : #accessing }
ARDrone >> visionDetectAnalyst [
	^ visionDetectAnalyst 
]

{ #category : #'public api-move' }
ARDrone >> yaw: angularSpeed [
	"Makes the drone yaw according to the speed specified by angularSpeed.
	The drone will keep rotating at angularSpeed velocity until its angularSpeed is set again by this function or by moveByLeftRightTilt:frontBackTilt:angularSpeed:verticalSpeed:
	Arguments:
	- angularSpeed (yaw)
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left."
	self motionState 
		angularSpeed: angularSpeed.
]
