"
I'm the ARDrone's command manager, my main responsibility is to use the  ARDrone instance adapters to send AT̈*commands, and provide a friendly api for sending messages to control the drone's movements and configuration.

IMPORTANT: It's the user's responsibility to terminate each instance of this class using the message ARDCommandManager>> terminate (this message is called from ARDrone terminateSession). If an instance is not terminated, two processes will keep running in background. 


I run two processes that send commands automatically: 
	- The senderProcess dequeues and send commands enqueued by the user using the message enqueue 
	- The motionCommandsSenderProcess permanently sends commands for controlling the drone's movements, acording to the ARDMotionState value of the arDrone's instance refered by the arDrone instance variable

Instance variables: 
	- arDrone <ARDrone>
	- commandsQueue  <SharedQueue>
	- senderProcess <Process>
	- motionCommandsSenderProcess <Process>

API messages:
	- ARDCommandManager class >> withARDrone:
			-> returns an instance of the class.
		
	- ARDCommandManager >> enqueue:
			-> enqueues the command received as argument, so that the sender process can dequeue it and send it automatically when its turn arrives 
	
	- ARDCommandManager >> land 
			-> sends the land command until the drone's fly mask is 0 (drone landed)

	- ARDCommandManager >> takeOff		
			-> sends the takeoff command until the drone's fly mask is 1 (drone flying)

	- ARDCommandManager >> animateLEDs:  frequency:  duration:  seq: 
			-> sends a single command to animate drone's LED 

	- ARDCommandManager >> terminate	
			-> terminates all processes related to this instance
"
Class {
	#name : #ARDCommandManager,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'commandsQueue',
		'senderProcess',
		'motionCommandsSenderProcess',
		'applicationId',
		'profileId',
		'sessionId',
		'stabilizeCommandSent',
		'lastMotionStateSent',
		'suspendProcesses'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDCommandManager class >> withARDrone: anARDrone [
	"Returns an ARDCommandManager instance for managing sending AT commands to the drone. 
	The argument type must be:
	- anARDrone <ARDrone>"
	^ (self new)
		arDrone: anARDrone 
]

{ #category : #'api-configuration CONTROL' }
ARDCommandManager >> animateFlight: aFlightAnimationNumber duration: anInt [ 
	"Sends a command for animating the ar drone flight. 
	FlightAnimation - [ Integer ] 
	Duration - [ milliseconds ]"
	| arg command |
	arg := aFlightAnimationNumber asString, ',' asString, anInt asString.
	command := (ARDCommand withPrefix: 'AT*CONFIG' 
									 arguments: { 'control:flight_anim'.
													  arg asString }).
	self enqueue: command.
]

{ #category : #'api-configuration LEDS' }
ARDCommandManager >> animateLEDs: aLedAnimationNumber frequency: aFloat duration: anInt [ 
	"Sends a command for animating the ar drone LEDs. 
	LedAnimation - [ Integer ] Enumeration, its values are defined in the ARDCommand class side.
	Frequency - [ Hertz ]
	Duration - [ seconds ]
	Seq - [ Integer ] is the sequence number of the AT command"
	self enqueue: (ARDCommand withPrefix: 'AT*LED' 
									 arguments: {aLedAnimationNumber. 
													aFloat asFloat asARDEquivalentInteger. 
													anInt}) .
]

{ #category : #accessing }
ARDCommandManager >> arDrone [
	"Returns the ARDrone instance for which this Command Manager was created"
	^ arDrone
]

{ #category : #accessing }
ARDCommandManager >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Command Manager was created"
	arDrone := anARDrone
	
]

{ #category : #accessing }
ARDCommandManager >> commandsQueue [
	"Returns the queue of commands that havent been sent yet"
	^ commandsQueue
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configApplicationDescription: aString [
	"Sets the current application description string."
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'custom:application_desc' . 
													aString }.
	self enqueue: command.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configApplicationId: aString [
	"Sets the current application id."

	| command |
	command := ARDCommand
		withPrefix: 'AT*CONFIG'
		arguments:
			{'custom:application_id'.
			aString}.
	self enqueue: command.
	applicationId := (aString at: 1) = $-
		ifTrue: [ nil ]
		ifFalse: [ aString ]
]

{ #category : #'api-configuration GENERAL' }
ARDCommandManager >> configControlMode: aControlMode [
	"Used in ARDConfigurationManager >> requestAndReceieConfigurationFile."
	| command |
	command := 
	ARDCommand 
		withPrefix: 'AT*CTRL'
		arguments: { aControlMode . 0 }.
	self enqueue: command. 
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configDefaultMulticonfig [
	| n |
	
	profileId := '00000000'.
	sessionId := '00000000'.
	applicationId := '00000000'.
	"
	n := ARDrone CRC32From: ((Random new next * 100000000) rounded asString).  
	self configSessionId: n.
	self configSessionDescription: 'Session', n.
	
	self configResetApplicationId: '64fb6da3'.
	self configApplicationDescription: 'Pharo Application'."
]

{ #category : #'api-configuration DETECT' }
ARDCommandManager >> configDetectType: anInt [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'detect:detect_type' . 
													anInt asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration DETECT' }
ARDCommandManager >> configDetectionsDefault [
	self configDetectType: ARDConstant detectType_MULTIPLE_DETECTION_MODE  .
	
	self configDetectionsSelectV: ARDConstant tagType_BLACK_ROUNDEL.
	self configDetectionsSelectH: ARDConstant tagType_SHELL_TAG_V2.
]

{ #category : #'api-configuration DETECT' }
ARDCommandManager >> configDetectionsSelectH: anInt [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'detect:detections_select_h' . 
													anInt asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration DETECT' }
ARDCommandManager >> configDetectionsSelectV: anInt [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'detect:detections_select_v' . 
													anInt asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration DETECT' }
ARDCommandManager >> configEnemyColors: anInt [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'detect:enemy_colors' . 
													anInt asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration CONTROL' }
ARDCommandManager >> configFlightWithoutShell: aBoolean [
	"Tells the drone firmware wether the drone is using the outdoor hull or not. Set to false if the drone is using the indoor hull. 
	Argument: 
	- aBoolean: True for outdoor hull, False for indoor hull."
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'control:flight_without_shell' . 
													 aBoolean 
														ifTrue:[ 'TRUE' ] 
														ifFalse: [ 'FALSE' ]}.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration CONTROL' }
ARDCommandManager >> configFlyingMode: aFlyingMode [
	"Sets flying mode for the drone, there are 3 possibilities: FREE FLIGHT, HOVER ON TOP OF ROUNDEL and HOVER ON TOP OF ORIENTED ROUNDEL. 
	Argument: 
	- aFlyingMode: Integer (enumeration defined in ARDConstant class side)"
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'control:flying_mode' . 
													aFlyingMode asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration GENERAL' }
ARDCommandManager >> configNavdataDefaultOptions [
	
	"Configure tag detection"
	Transcript show: 'config';cr.
	self configSessionId: '-all'.
	
	(self configNavdataDemo: true)
	ifFalse: [^ false].
	self configDefaultMulticonfig.
	self configNavdataOptions: { 
		ARDConstant option_DEMO.
		ARDConstant option_VISION_DETECT }.
	
	self configControlMode: ARDConstant controlMode_ACK_CONTROL_MODE.
	

	
	self configDetectionsDefault. 
	
	self configEnemyColors: ARDConstant detectionColor_ORANGE_BLUE. 
	self configVideoCodec: ARDConstant videoCodec_H264_720P_CODEC.
	self configVideoChannel: ARDConstant videoChannel_ZAP_CHANNEL_HORI.
	
	^ true.
]

{ #category : #'api-configuration GENERAL' }
ARDCommandManager >> configNavdataDemo: aBoolean [
	"comment stating purpose of message"
	| command lastPacketState |
	
	lastPacketState := arDrone navdataManager lastDatagramReceived header state.
	"if the bootstrap bit is set to 0, then the navdata demo option has been set before (maybe by another app), and can't be set again. The drone must be restarted"
	(lastPacketState navdataBootstrap = 0) 
	ifTrue: [ 
		"check wether the navdataDemo option in the drone matches the desired value"
		((lastPacketState navdataDemo = 1) ~= aBoolean) ifTrue: [ ^ false ]].
	
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'general:navdata_demo' . 
													aBoolean 
														ifTrue:[ 'TRUE' ] 
														ifFalse: [ 'FALSE' ]}.
	self enqueue: command.
	^ true.
]

{ #category : #'api-configuration GENERAL' }
ARDCommandManager >> configNavdataOptions: anArray [
	| command options |
	options := Integer from32BitArrayWithOnesAt: anArray.
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'general:navdata_options' . 
													options asString }.
	self enqueue: command. 
]

{ #category : #'api-configuration CONTROL' }
ARDCommandManager >> configOutdoor: aBoolean [
	"Tells the drone firmware if the drone is flying outdoors. (Changes the max velocity and tilts, and enabled the wind estimator)
	Argument: 
	- aBoolean: True for outdoors, False for indoors."
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'control:outdoor' . 
													 aBoolean 
														ifTrue:[ 'TRUE' ] 
														ifFalse: [ 'FALSE' ]}.
	self enqueueWithConfigIds: command. 
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configProfileDescription: aString [
	"Sets the current profile description string."
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'custom:profile_desc' . 
													aString }.
	self enqueue: command.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configProfileId: aString [
	"Sets the current profile description string."

	| command |
	command := ARDCommand
		withPrefix: 'AT*CONFIG'
		arguments:
			{'custom:profile_id'.
			aString}.
	self enqueue: command.
	profileId := (aString at: 1) = $-
		ifTrue: [ nil ]
		ifFalse: [ aString ]
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configResetApplicationId: aString [
	"Sets the current profile description string."
	self configApplicationId: '-', aString.
	self configApplicationId: aString.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configResetProfileId: aString [
	"Sets the current profile description string."
	self configProfileId: '-', aString.
	self configProfileId: aString.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configResetSessionId: aString [
	"Sets the current profile description string."
	self configSessionId: '-', aString.
	self configSessionId: aString.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configSessionDescription: aString [
	"Sets the current session description string."
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'custom:session_desc' . 
													aString }.
	self enqueue: command.
]

{ #category : #'api-configuration CUSTOM' }
ARDCommandManager >> configSessionId: aString [
	"Sets the current session id."

	| command |
	command := ARDCommand
		withPrefix: 'AT*CONFIG'
		arguments:
			{'custom:session_id'.
			aString}.
	self enqueue: command.
	sessionId := (aString at: 1) = $-
		ifTrue: [ nil ]
		ifFalse: [ aString ]
]

{ #category : #'api-configuration VIDEO' }
ARDCommandManager >> configVideoChannel: anInt [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'video:video_channel' . 
													anInt asString }.
	
	self enqueueWithConfigIds: command.
	 
]

{ #category : #'api-configuration VIDEO' }
ARDCommandManager >> configVideoCodec: anInt [
	"sets the video codification of the video stream sent by the drone"
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { 'video:video_codec' . 
													anInt asString }.
	
	self enqueueWithConfigIds: command.
	 
]

{ #category : #'api-control Progressive Movements' }
ARDCommandManager >> elevateTo: anAltitude atSpeed: aSpeed [
	"elevates (ascend or descend) the drone, to the desired altitude (confirmed via navdata).
	Argument: 
		- anAltitude: Integer representing the desired altitude in centimeters
		- aSpeed: Float in [0, 1] representing a percentage of the max elevation velocity configured for the drone"
	[[ | initialDifference difference epsilon velocity |
		initialDifference := (anAltitude - arDrone altitude).
		difference := initialDifference.
		epsilon := 100*(1+aSpeed).
		velocity := aSpeed * (difference sign).		
		
		(arDrone isFlying & ( difference abs > epsilon))
			ifTrue: [ 
				arDrone elevate: velocity.	
				[[ difference abs > epsilon ] 
					whileTrue: [ 
						"difference is the remaining distance to go yet"
						difference := (anAltitude - arDrone altitude).
						"Velocity decreases along with the difference"
						velocity := ((velocity abs) - 
										(velocity*(1-(difference/initialDifference)) abs)) * 
										(difference sign).
						(Delay forMilliseconds: 20) wait ]] 
				ensure: [arDrone stabilize]]
	] valueWithin: 2 second onTimeout: [ Transcript show: 'Timeout on elevating, error';cr ]]fork
]

{ #category : #api }
ARDCommandManager >> enqueue: anARDCommand [
	"Enqueues anARDCommand in the commandsQueue. The enqueued command will be properly dequeued and send automatically by the senderProcess."
	commandsQueue nextPut: anARDCommand
]

{ #category : #private }
ARDCommandManager >> enqueueLandCommand [
	"Enqueues a single land command"
	self enqueue: (ARDCommand withPrefix: 'AT*REF' 
									 arguments: {Integer from32BitArrayWithOnesAt: { 18 . 20 . 22 . 24 . 28 }})
]

{ #category : #private }
ARDCommandManager >> enqueueTakeOffCommand: exitEmergencyState [
	"Enqueues a single take off command"
	| onesIndex |
	onesIndex := { 9 . 18 . 20 . 22 . 24 . 28 } .
	exitEmergencyState 
		ifTrue: [ onesIndex := {8}, onesIndex ] .
	self enqueue: (ARDCommand withPrefix: 'AT*REF'
									 arguments: {Integer from32BitArrayWithOnesAt: onesIndex })
]

{ #category : #api }
ARDCommandManager >> enqueueWithConfigIds: anARDCommand [
	"Sends a config_ids command, and then enqueues the anARDCommand in the commandsQueue."
	| commandIds |
	commandIds := ARDCommand withPrefix: 'AT*CONFIG_IDS'  
									arguments: { sessionId. profileId. applicationId }. 

	self enqueue: commandIds.
	self enqueue: anARDCommand. 
]

{ #category : #api }
ARDCommandManager >> flatTrim [
	"Sends the flat trim command"
	self enqueue: (ARDCommand withPrefix: 'AT*FTRIM'
									 arguments: { }) .
]

{ #category : #initialize }
ARDCommandManager >> initialize [
	super initialize.
	suspendProcesses := false.
	commandsQueue := SharedQueue new.
	self initializeProcessMotionCommandsSender.
	self initializeProcessQueuedCommandsSender.

]

{ #category : #initialize }
ARDCommandManager >> initializeProcessMotionCommandsSender [
	"initializes the process responsible for permanently sending motion commands to the drone (sends one command every 30 milliseconds)"
	| motionState |
	motionCommandsSenderProcess :=
	[[ (self suspendProcesses) ifTrue: [Processor activeProcess suspend].
		(arDrone hasReceivedNavdata)
			ifTrue:
			 [ (arDrone isFlying) 
					ifTrue: 
					[	motionState := arDrone motionState.
						self sendMoveCommandOnlyIfNecessary: motionState ]
					ifFalse:
					[ (Delay forMilliseconds: 30) wait. ]]
			ifFalse: 
			[ (Delay forMilliseconds: 30) wait. ]
		] repeat ] newProcess.
	motionCommandsSenderProcess name: 'Motion commands sender process'.
	
]

{ #category : #initialize }
ARDCommandManager >> initializeProcessQueuedCommandsSender [
	"initializes the process that permanently dequeues commands from the commandsQueue"
	senderProcess := [[ | nextCommand |
							(self suspendProcesses) ifTrue: [Processor activeProcess suspend].
							"dequeue the next command, enumerate it and send it"
							nextCommand := commandsQueue next .
							arDrone commandAdapter send: nextCommand 
						] repeat ] newProcess.
	senderProcess name: 'Queued commands sender process'.
]

{ #category : #api }
ARDCommandManager >> land [
	"Every 1 second sends the land command to the drone, until it's state goes from Flying to Landed (ARDState flyMask from 0 to 1)"
	arDrone connectionState ~= ARDConstant connection_CONNECTED
		ifTrue: [ Transcript show: 'Drone disconnected';cr. ^ self ]. 
	[[ | flying |
		flying := arDrone isFlying.
		flying 
			ifTrue: [ arDrone 
							announcer 
						 	subscribe: DroneLanded 
						  	do:[arDrone announcer unsubscribe: self. 
								 flying := false]  ].
		[ flying ] whileTrue: [ self enqueueLandCommand. 
							 		 (Delay forSeconds: 1) wait ] 
	] valueWithin: 10 second onTimeout: [ Transcript show: 'Timeout on landing' ]] fork
]

{ #category : #'api-control Progressive Movements' }
ARDCommandManager >> moveFor: aDuration atSpeed: aSpeed withDirection: anAngle [
	"Moves the drone progressivelly for aTimeInterval time, with maximum speed aSpeed, in the direction indicated by anAngle.
	Argument: 
		- aDuration: Integer, in milli seconds
		- aSpeed: Float in [0, 1] representing a percentage of the max roll and pitch velocity configured for the drone
		- anAngle: Integer in [ 0, 360 ], represents the direction in wich the drone will move. Looking the drone from above, the zero is in the drone's nose, and increments clockwise."
	[[ | timeStart msecondsElapsed speed pitch roll temporalFactor |
		timeStart := Time now asMilliSeconds.
		msecondsElapsed := 0.
		
		(arDrone isFlying)
			ifTrue: [ 
				[[ msecondsElapsed <= aDuration ] 
					whileTrue: [ 
						
						temporalFactor := ((msecondsElapsed * 180.0) / aDuration) degreeSin.
						speed := aSpeed * temporalFactor.
						pitch := speed * (anAngle degreeCos) negated.
						roll := speed * (anAngle degreeSin).
						arDrone pitch: pitch.
						arDrone roll: roll.
						
						"Speed starts at zero and increments progressivelly. It has its maximum value in the middle of the trayectory, and then decreases until it is zero."
						msecondsElapsed := Time now asMilliSeconds - timeStart.
						(Delay forMilliseconds: 30) wait ]] 
				ensure: [arDrone stabilize]]
	] valueWithin: aDuration second onTimeout: [ Transcript show: 'Timeout on moving progressivelly, error';cr ]]fork
]

{ #category : #api }
ARDCommandManager >> resume [
	"Resume the processes associated to this instance."
	self suspendProcesses: false.
	senderProcess resume.
	motionCommandsSenderProcess resume.
]

{ #category : #private }
ARDCommandManager >> sendMoveCommand: aMotionState [
	self sendMoveCommandLeftRightTilt: aMotionState leftRightTilt 
							 frontBackTilt: aMotionState frontBackTilt 
							verticalSpeed: aMotionState verticalSpeed 
						   angularSpeed: aMotionState angularSpeed. 
]

{ #category : #private }
ARDCommandManager >> sendMoveCommandLeftRightTilt: lrTilt frontBackTilt: fbTilt verticalSpeed: verticalSpeed angularSpeed: angularSpeed [
	"Checks the arDrone's motion state, and sends the apropriate command for controlling the drone's movements.
	Arguments:
	- lrTilt (roll or phi angle) 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 									 			- (-) for left, (+) for right.
	- fbTilt (pitch or theta angle) 
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 
			- (-) for front (drone lowers its nose), (+) for back (drone raise its nose)
	- verticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending.
	- angularSpeed 
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left."
	| moveCommand onlyZeros| 
	onlyZeros := (lrTilt = 0) & (fbTilt = 0) & (verticalSpeed = 0) & (angularSpeed = 0).
	moveCommand := ARDCommand withPrefix: 'AT*PCMD'
			 						arguments: {(onlyZeros ifTrue: [0] ifFalse: [1]).
													lrTilt asARDEquivalentInteger. 
													fbTilt asARDEquivalentInteger. 
													verticalSpeed asARDEquivalentInteger. 
													angularSpeed asARDEquivalentInteger }.
	arDrone commandAdapter send: moveCommand. 
]

{ #category : #private }
ARDCommandManager >> sendMoveCommandOnlyIfNecessary: aMotionState [
	| motionState |
	motionState := aMotionState copy.
	( motionState containsOnlyZeros ) 
			ifTrue: [ ( self stabilizeCommandSent ) 
							ifFalse: 
							[ "send 3 motion commands with zeros only, to increase the chance for the drone receiving at least one of them"
							1 to: 3 do: [:i | self sendMoveCommand: motionState ].  
							self stabilizeCommandSent: true. ] ]
			ifFalse: [ self sendMoveCommand: motionState.
						  self stabilizeCommandSent: false. ]
							 
]

{ #category : #api }
ARDCommandManager >> setConfigFor: aParameter value: aVal [
	| command |
	command := ARDCommand withPrefix: 'AT*CONFIG' 
			 						arguments: { aParameter asString . 
													aVal asString }.
	self enqueueWithConfigIds: command. 
]

{ #category : #private }
ARDCommandManager >> stabilizeCommandSent [
	^ stabilizeCommandSent ifNil: [ stabilizeCommandSent := false. ]
]

{ #category : #private }
ARDCommandManager >> stabilizeCommandSent: aBoolean [
	stabilizeCommandSent := aBoolean
]

{ #category : #api }
ARDCommandManager >> suspend [
	"Resume the processes associated to this instance."
	self suspendProcesses: true.
	commandsQueue flushAllSuchThat: [ :cmd | (cmd isMemberOf: ARDCommand) ifFalse: [ ^ true ] .
															cmd isAStabilizeCommand not ] .
	lastMotionStateSent := nil.

	
]

{ #category : #private }
ARDCommandManager >> suspendProcesses [

	^ suspendProcesses
]

{ #category : #private }
ARDCommandManager >> suspendProcesses: aBoolean [
	"If this variables is true, then the sender processes must be suspended after their next cycle"
	suspendProcesses := aBoolean
]

{ #category : #api }
ARDCommandManager >> takeOff [
	"Every 1 second sends the take off command to the drone, until it's state goes from Landed to Flying (ARDState flyMask from 0 to 1)"
	arDrone connectionState ~= ARDConstant connection_CONNECTED
		ifTrue: [ Transcript show: 'Drone disconnected';cr. ^ self ]. 
	self flatTrim.
	self arDrone stabilize.
	[[ | landed |
			landed := arDrone isFlying not.
			landed 
				ifTrue: [ arDrone 
								announcer 
						  		subscribe: DroneTookOff 
						  		do:[arDrone announcer unsubscribe: self. 
								 	landed := false]  ].
		[ landed ] whileTrue: [ self flatTrim.
										self enqueueTakeOffCommand: (arDrone isInEmergencyState).
							 		 (Delay forSeconds: 2.5) wait ] 
	] valueWithin: 8 second onTimeout: [ Transcript show: 'Timeout on taking off';cr ]]fork
]

{ #category : #api }
ARDCommandManager >> terminate [
	"Terminate must be called when you finish using ARDCommandManager. If you don't, the sender process will keep running background."
	senderProcess terminate.
	motionCommandsSenderProcess terminate.
]
