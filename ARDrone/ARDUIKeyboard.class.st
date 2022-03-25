"
I'm a morph that listens to keyboard events and controls the Drone  according to the keys pressed

Instance Variables
	arDrone:		<ARDrone>
"
Class {
	#name : #ARDUIKeyboard,
	#superclass : #Morph,
	#instVars : [
		'arDrone',
		'enabled',
		'pressedKeys',
		'moveKeysDict',
		'ledKeysDic',
		'pirouetteKeysDict',
		'speed',
		'ledFrequency',
		'ledDuration',
		'pirouetteDuration',
		'motionStateUI'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDUIKeyboard class >> defaultColorFocused [
	^ Color colorFrom: #(0.1 0.6 1)
]

{ #category : #'instance creation' }
ARDUIKeyboard class >> defaultColorNotFocused [
	^ Color colorFrom: #(0.9 0.95 1)
]

{ #category : #test }
ARDUIKeyboard class >> startTest: showNavdata [
	[
		|ui arDrone|
		arDrone := ARDrone newUniqueInstance.
		arDrone addHandlerFor: DroneConnectionInterrupted 
				  do: [ :ex | Transcript show: 'Connection interrupted';cr. ].
		arDrone addHandlerFor: PrimitiveFailed 
				  do: [ :ex | Transcript show: 'Primitive failed!!';cr. ].
		
		arDrone startSession.
		showNavdata ifTrue: [ arDrone setNavdataReceiverCallback: [ :dg | Transcript show: dg asString ]].
		ui := self withARDrone: arDrone.
		ui openInWorld.
	] fork .
	Transcript clear.
]

{ #category : #'instance creation' }
ARDUIKeyboard class >> withARDrone: anARDrone [
	"Returns a UI keyboard for receiving navigation data from anARDrone"
	^ (self new)
			arDrone: anARDrone
]

{ #category : #'event handling' }
ARDUIKeyboard >> arDrone [
	"Returns the ARDrone instance for which this UI Keyboard was created"
	^ arDrone
]

{ #category : #'event handling' }
ARDUIKeyboard >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this UI Keyboard was created"
	arDrone := anARDrone.
	motionStateUI arDrone: anARDrone. 
]

{ #category : #configuring }
ARDUIKeyboard >> configureLedDuration: anIntLed ledFrequency: aFloatLed pirouetteDuration: anIntPir speed: aFloatSpeed [
	"configures values for the led animations, pirouettes and speed for the drone movements.
	arguments:
		- anIntLed: Led animations duration in seconds
		- aFloatLed: Led animations frequency in Hz
		- anIntPir: Pirouettes duration in milliseconds
		- aFloatSpeed: percentage of the maximum speed/inclination for the move commands. Must be in [ 0, 1 ]"
	self ledDuration: anIntLed.
	self ledFrequency: aFloatLed.
	self pirouetteDuration: anIntPir.
	self speed: aFloatSpeed. 
]

{ #category : #'event handling' }
ARDUIKeyboard >> enabled: aBoolean [
	super enabled: aBoolean.
	enabled := aBoolean.
	motionStateUI enabled: aBoolean.
]

{ #category : #'events-processing' }
ARDUIKeyboard >> handleKeyDown: anEvent [
	
	| keyValue |
	super handleKeyDown: anEvent.
	enabled ifFalse: [ ^ false ].
	keyValue := anEvent keyValue.
	"Transcript show: keyValue asString;cr."
	"check the key state in the keyDownWasAlreadyHandled dictionary"
	(self  keyDownWasAlreadyHandled: keyValue) ifTrue: [ ^ false ].
	"perform the corresponding action according to the values saved in the dictionaries"
	moveKeysDict 
		at: keyValue 
		ifPresent: [ :cmd | 
			cmd value: speed. self color: Color green. ^ true ].
	ledKeysDic 
		at: keyValue 
		ifPresent: [ :cmd | 
			cmd value . self color: Color yellow. ^ true ].
	pirouetteKeysDict  
		at: keyValue 
		ifPresent: [ :cmd | 
			cmd value . self color: Color blue. ^ true ].
	^ false.
]

{ #category : #'event handling' }
ARDUIKeyboard >> handleKeyUp: anEvent [
	| keyValue defaultColor keyIsPressed |
	enabled ifFalse: [ ^ 0 ].
	
	keyValue := anEvent keyValue.
	keyIsPressed := pressedKeys at: keyValue ifAbsentPut: false .
	keyIsPressed ifFalse: [ ^ 0 ].
	pressedKeys at: keyValue put: false.

	defaultColor := self class defaultColorFocused.
	
	moveKeysDict 
		at: keyValue 
		ifPresent: [ :cmd | 
			cmd value: 0. self color: defaultColor. ^ true ].
	ledKeysDic 
		at: keyValue 
		ifPresent: [ :cmd | 
			self color: defaultColor. ^ true ].
	pirouetteKeysDict  
		at: keyValue 
		ifPresent: [ :cmd | 
			self color: defaultColor. ^ true ].
]

{ #category : #'event handling' }
ARDUIKeyboard >> handleKeystroke: anEvent [
	| keyValue |
	enabled ifFalse: [ ^ 0 ].
	
	keyValue := anEvent keyValue.
	keyValue = 32 "space bar"
		ifTrue: [ arDrone takeOff ].
	keyValue = 13 "enter"
		ifTrue: [ arDrone land ].
	keyValue = 27 "ESC"
		ifTrue: [ arDrone terminateSession. 
					self delete ].
	
]

{ #category : #'event handling' }
ARDUIKeyboard >> handleMouseDown: anEvent [
	ActiveHand keyboardFocus: self.
]

{ #category : #'event handling' }
ARDUIKeyboard >> handlesKeyboard: anEvent [
	^ true
]

{ #category : #'event handling' }
ARDUIKeyboard >> handlesMouseDown: anEvent [
	^ true
]

{ #category : #'event handling' }
ARDUIKeyboard >> initialize [
	super initialize.
	motionStateUI := ARDUIMotionState new.
	self height: motionStateUI height.
	self width: motionStateUI width.
	self color: self class defaultColorNotFocused.
	self enabled: true.
	self addMorph: motionStateUI.
	
	pirouetteDuration := 4000.
	speed := 0.25.
	ledFrequency := 2.
	ledDuration := 5.
	
	self initializeMoveKeysDict.
	self initializeLedKeysDict.
	self initializePirouetteKeysDict. 
	
	pressedKeys := Dictionary new.
	ActiveHand keyboardFocus: self.
]

{ #category : #private }
ARDUIKeyboard >> initializeLedKeysDict [
	| animateLedsCmd |
	
	animateLedsCmd := [ :anim |
		arDrone animateLEDs: anim frequency: ledFrequency duration: ledDuration ].
	
	ledKeysDic := {
		"1  -> blink green" 			
		49  -> [ animateLedsCmd value: ARDConstant ledAnimation_BLINK_GREEN. Transcript show: arDrone altitude asString; cr  ].
		"2  -> blink red"
		50  -> [ animateLedsCmd value: ARDConstant ledAnimation_BLINK_RED  ].
		"3  -> "
		51  -> [ animateLedsCmd value: ARDConstant ledAnimation_BLINK_ORANGE ].
		"4  -> "
		52  -> [ animateLedsCmd value: ARDConstant ledAnimation_FIRE  ].
		"5  -> "
		53  -> [ animateLedsCmd value: ARDConstant ledAnimation_RED_SNAKE ].
		"6  -> "
		54  -> [ animateLedsCmd value: ARDConstant ledAnimation_SNAKE_GREEN_RED ].
		"7  -> "
		55  -> [ animateLedsCmd value: ARDConstant ledAnimation_DOUBLE_MISSILE ].
		"8  -> "
		56  -> [ animateLedsCmd value: ARDConstant ledAnimation_FRONT_LEFT_GREEN_OTHERS_RED ].
		"9  -> "
		57  -> [ animateLedsCmd value: ARDConstant ledAnimation_FRONT_RIGHT_GREEN_OTHERS_RED ].
		"0  -> "
		48  -> [ animateLedsCmd value: ARDConstant ledAnimation_GREEN  ].
	} asDictionary.
]

{ #category : #private }
ARDUIKeyboard >> initializeMoveKeysDict [
	moveKeysDict := {
	"W -> move forward" 		119 -> [ :v | arDrone pitch: 	v negated ].
	"S -> move backwards" 	115 -> [ :v | arDrone pitch: 	v 			 ].
	"Q -> roll left" 			113 -> [ :v | arDrone roll: 	v negated ].
	"E -> roll right" 			101 -> [ :v | arDrone roll: 	v 			 ].
	"F -> elevate" 				102 -> [ :v | arDrone elevate: v 			 ].
	"C -> descend" 				99  -> [ :v | arDrone elevate: v negated ].	
	"D -> rotate cw" 			100 -> [ :v | arDrone yaw: 		v 			 ].
	"A -> rotate ccw" 			97  -> [ :v | arDrone yaw: 		v negated ].
	} asDictionary.
]

{ #category : #private }
ARDUIKeyboard >> initializePirouetteKeysDict [
	| animateFlightCmd |
	
	animateFlightCmd := [ :anim | arDrone animateFlight: anim duration: pirouetteDuration ].
	
	pirouetteKeysDict := {
	"!" 33  -> [ animateFlightCmd value: ARDConstant flightAnimation_FLIP_AHEAD ].
  "''" 34  -> [ animateFlightCmd value: ARDConstant flightAnimation_FLIP_BEHIND ].
	"#" 35  -> [ animateFlightCmd value: ARDConstant flightAnimation_FLIP_LEFT ].
	"$" 36  -> [ animateFlightCmd value: ARDConstant flightAnimation_FLIP_RIGHT  ].
	"%" 37  -> [ animateFlightCmd value: ARDConstant flightAnimation_WAVE ].
	"&" 38  -> [ animateFlightCmd value: ARDConstant flightAnimation_DOUBLE_PHI_THETA_MIXED ].
	"/" 47  -> [ animateFlightCmd value: ARDConstant flightAnimation_YAW_SHAKE  ].
	"(" 40  -> [ animateFlightCmd value: ARDConstant flightAnimation_TURNAROUND ].
	")" 41  -> [ animateFlightCmd value: ARDConstant flightAnimation_THETA_20DEG_YAW_200DEG ].
	"=" 61  -> [ animateFlightCmd value: ARDConstant flightAnimation_YAW_DANCE ].
	} asDictionary.
]

{ #category : #private }
ARDUIKeyboard >> keyDownWasAlreadyHandled: keyValue [
	
	(pressedKeys at: keyValue ifAbsentPut: false) ifTrue: [ ^ true ].
	pressedKeys at: keyValue put: true.
	^ false.
]

{ #category : #'event handling' }
ARDUIKeyboard >> keyboardFocusChange: gotFocus [
	super keyboardFocusChange: gotFocus.
	"(gotFocus & enabled) 
		ifTrue: [ self color: self class defaultColorFocused ] 
		ifFalse: [ self color: self class defaultColorNotFocused  ]."
	enabled ifTrue: [ motionStateUI gotFocus: gotFocus ].
]

{ #category : #accessing }
ARDUIKeyboard >> ledDuration [

	^ ledDuration
]

{ #category : #accessing }
ARDUIKeyboard >> ledDuration: anInt [
	"Led animations duration in seconds"
	ledDuration := anInt
]

{ #category : #accessing }
ARDUIKeyboard >> ledFrequency [

	^ ledFrequency
]

{ #category : #accessing }
ARDUIKeyboard >> ledFrequency: aFloat [
	"Led animations frequency in Hz"
	ledFrequency := aFloat
]

{ #category : #accessing }
ARDUIKeyboard >> pirouetteDuration [

	^ pirouetteDuration
]

{ #category : #accessing }
ARDUIKeyboard >> pirouetteDuration: anInt [
	"pirouette duration in milliseconds"
	pirouetteDuration := anInt
]

{ #category : #accessing }
ARDUIKeyboard >> speed [

	^ speed
]

{ #category : #accessing }
ARDUIKeyboard >> speed: aFloat [
	"percentage of the maximum speed/inclination for the move commands. 
	argument: aFloat must be in [0 , 1]"
	speed := aFloat
]
