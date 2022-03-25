"
I'm a morph that reflects graphically the current motion state of its drone instance 
"
Class {
	#name : #ARDUIMotionState,
	#superclass : #Morph,
	#instVars : [
		'arDrone',
		'forward',
		'backward',
		'left',
		'right',
		'cw',
		'cc',
		'up',
		'down',
		'speed',
		'keysArray',
		'activeColorFocused',
		'inactiveColorFocused',
		'activeColorDefocused',
		'inactiveColorDefocused',
		'disabledColor',
		'enabled',
		'gotFocus'
	],
	#category : #ARDrone
}

{ #category : #accessing }
ARDUIMotionState >> activeColor [
	enabled 
		ifFalse: [ ^ disabledColor. ].
	gotFocus 
		ifTrue: [ ^ activeColorFocused ]
		ifFalse: [ ^ activeColorDefocused ]
]

{ #category : #'event handling' }
ARDUIMotionState >> arDrone [
	"Returns the ARDrone instance for which this UI Keyboard was created"
	^ arDrone
]

{ #category : #'event handling' }
ARDUIMotionState >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this UI Keyboard was created"
	arDrone := anARDrone
]

{ #category : #'stepping and presenter' }
ARDUIMotionState >> containerColor [
	 
	enabled 
		ifTrue: [ ^ self enabledColor ]
		ifFalse: [ ^ self disabledColor ]
]

{ #category : #accessing }
ARDUIMotionState >> disabledColor [
	^ disabledColor
]

{ #category : #accessing }
ARDUIMotionState >> enabled: aBoolean [
	super enabled: aBoolean.
	enabled := aBoolean.
	
]

{ #category : #accessing }
ARDUIMotionState >> enabledColor [
	^ Color fromHexString: 'bfbfbf'
]

{ #category : #accessing }
ARDUIMotionState >> gotFocus: aBoolean [
 	gotFocus := aBoolean.
	self updateColors 
]

{ #category : #accessing }
ARDUIMotionState >> inactiveColor [
	gotFocus 
		ifTrue: [ ^ inactiveColorFocused ]
		ifFalse: [ ^ inactiveColorDefocused ]
]

{ #category : #initialization }
ARDUIMotionState >> initialize [
	| h w p1 p2 trans |
	super initialize.
	enabled := false.
	gotFocus := false.
	
	h := 30.
	w := 30.
	p1 := 0@0.
	p2 := (w*3.5)@0.
	
	self initializeColors.
	self initializeSpeedLabel.
	self initializeKeyMorphsWidth: w height: h position1: p1 position2: p2.
	
	self 
		width: w*6.5; 
		height:h*3.
	
	trans:= (TransformationMorph new asFlexOf: backward).
	trans angle: 3.14.
	
	keysArray := { forward . trans . left . right . up . down . cc . cw }.
	keysArray do: [ :each | self addMorph: each ].
	self addMorph: speed.
	self updateColors. 
	
]

{ #category : #initialization }
ARDUIMotionState >> initializeColors [
	activeColorFocused  := Color fromHexString: '4da9ff'.
	inactiveColorFocused := Color fromHexString: 'a6a6a6'. 
	activeColorDefocused := Color fromHexString: 'b3daff'.
	inactiveColorDefocused := Color fromHexString: 'cccccc'.
	 
	disabledColor := Color fromHexString:'f2f2f2'.
]

{ #category : #initialization }
ARDUIMotionState >> initializeKeyMorphsWidth: w height: h position1: p1 position2: p2 [
 
	forward 	:= 	self newKeyMorph: (Character value: 916) at: (w@0) + p1.
	backward 	:= self newKeyMorph: (Character value: 916) at: (w@(h*2)) + p1.
	cc 			:= self newKeyMorph: (Character value: 60) at: (0@h) + p1. 
	cw 			:= self newKeyMorph: (Character value: 62) at: ((2*w)@h) + p1. 
	
	up 			:= self newKeyMorph: (Character value: 8593) 	at: (w@0) + p2.
	down 		:= self newKeyMorph: (Character value: 8595) 	at: (w@(h*2)) + p2.  
	left 		:= self newKeyMorph: (Character value: 8592) 	at: (0@h) + p2.
	right 		:= self newKeyMorph: (Character value: 8594) 	at: ((2*w)@h) + p2.  
	
]

{ #category : #initialization }
ARDUIMotionState >> initializeSpeedLabel [
	speed := StringMorph new 
			position: 0@0;
			contents: 's:'.
]

{ #category : #'stepping and presenter' }
ARDUIMotionState >> keyColorBy: aBoolean [
	 
	aBoolean 
		ifTrue: [ ^ self activeColor ]
		ifFalse: [ ^ self inactiveColor ]
]

{ #category : #'instance creation' }
ARDUIMotionState >> newKeyMorph: aLabel at: aPoint [
	| morph label |
	morph := BorderedMorph  new
			color: self inactiveColor;
			width: 25;
			height: 25;
			position: (self bounds center - (self extent // 2)) + aPoint.
	label := StringMorph new 
			position: (morph bounds center - (morph extent // 4));
			contents: aLabel asString.
	morph addMorph: label.
	^ morph
		
]

{ #category : #'stepping and presenter' }
ARDUIMotionState >> step [
	((arDrone isNil) or: [ arDrone isConnected not ]) ifTrue: [ ^ self ].
	self updateColors.
	
]

{ #category : #stepping }
ARDUIMotionState >> stepTime [
	^ 100 
]

{ #category : #private }
ARDUIMotionState >> updateColors [
	| motionState |
	arDrone isNil
		ifTrue: [ 
			self color: disabledColor .
			forward 	color: disabledColor; borderColor: Color lightGray.
			backward 	color: disabledColor; borderColor: Color lightGray.
			left 		color: disabledColor; borderColor: Color lightGray.
			right 		color: disabledColor; borderColor: Color lightGray.
			up 			color: disabledColor; borderColor: Color lightGray.
			down 		color: disabledColor; borderColor: Color lightGray.
			cc 			color: disabledColor; borderColor: Color lightGray.
			cw 			color: disabledColor; borderColor: Color lightGray.]
	ifFalse: [ 
		motionState := arDrone motionState.
		
		forward 	color: (self keyColorBy: ( motionState frontBackTilt < 0)).
		backward 	color: (self keyColorBy: ( motionState frontBackTilt > 0)).
		left 		color: (self keyColorBy: ( motionState leftRightTilt < 0)).
		right 		color: (self keyColorBy: ( motionState leftRightTilt > 0)).
		up 			color: (self keyColorBy: ( motionState verticalSpeed > 0)).
		down 		color: (self keyColorBy: ( motionState verticalSpeed < 0)).
		cc 			color: (self keyColorBy: ( motionState angularSpeed  < 0)).
		cw 			color: (self keyColorBy: ( motionState angularSpeed  > 0)).	
	].
	
]

{ #category : #'stepping and presenter' }
ARDUIMotionState >> wantsSteps [
	^ true
]
