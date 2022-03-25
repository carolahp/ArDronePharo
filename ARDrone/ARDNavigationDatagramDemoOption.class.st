"
I'm the DEMO option (tag 0). I contain general  information about the drone's sensors
"
Class {
	#name : #ARDNavigationDatagramDemoOption,
	#superclass : #ARDNavigationDatagramOption,
	#instVars : [
		'ctrlState',
		'vbatFlyingPercentage',
		'theta',
		'phi',
		'psi',
		'altitude',
		'vx',
		'vy',
		'vz',
		'numFrames'
	],
	#category : #ARDrone
}

{ #category : #validation }
ARDNavigationDatagramDemoOption class >> validSize [
	^ 148
]

{ #category : #validation }
ARDNavigationDatagramDemoOption class >> validTag [
	^ 0
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> altitude [
	"altitude in centimeters"
	^ altitude
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> altitude: anInt [
	"altitude in centimeters"
	altitude := anInt
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> asString [
	"Returns the datagram demo option contents as string"
	| cr tab |
	cr := Character cr asString .
	tab := Character tab asString .
	^ tag 			asString, ' :tag ', cr ,
	size 			asString, ' :size ', cr ,
	(self ctrlStateString) 	asString, ' :control state ', cr ,
	vbatFlyingPercentage 
					asString, ' :batery ', cr ,
	theta 			asString, ' :pitch angle', cr ,
	phi 			asString, ' :roll angle', cr ,
	psi 			asString, ' :yaw angle', cr ,
	altitude 		asString, ' :altitude', cr ,
	vx 				asString, ' :estimated velocity x', cr ,
	vy 				asString, ' :estimated velocity y', cr ,
	vz 				asString, ' :estimated velocity z'
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> ctrlState [
	"Flying state (landed, flying, hovering, etc.) defined in CTRL_STATES enum."
	^ ctrlState
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> ctrlState: anInt [
	"Flying state (landed, flying, hovering, etc.) defined in CTRL_STATES enum."
	ctrlState := anInt
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> ctrlStateString [
	"Flying state (landed, flying, hovering, etc.) defined in CTRL_STATES enum."
	self ctrlState ifNil: [ ^ '' ].
	^ ARDConstant ctrlStates at: ((self ctrlState>>16) + 1)
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> numFrames [
	"for video stream"
	^ numFrames
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> numFrames: anInt [
	"for video stream"
	numFrames := anInt
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> phi [
	"roll angle in milli-degrees"
	^ phi
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> phi: aFloat [
	"roll angle in milli-degrees"
	phi := aFloat
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> psi [
	"yaw angle in milli-degrees"
	^ psi
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> psi: aFloat [
	"yaw angle in milli-degrees"
	psi := aFloat
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> theta [
	"pitch angle in milli-degrees"
	^ theta
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> theta: aFloat [
	"pitch angle in milli-degrees"
	theta := aFloat
]

{ #category : #updating }
ARDNavigationDatagramDemoOption >> updateFrom: anARDNavigationDatagramDemoOption [
	(anARDNavigationDatagramDemoOption size asInteger = self class validSize & 
	anARDNavigationDatagramDemoOption tag asInteger = self class validTag) 
	ifFalse: [^ false].
	
	self 
		tag: 			anARDNavigationDatagramDemoOption tag; 
		size: 			anARDNavigationDatagramDemoOption size;		
		ctrlState: 	anARDNavigationDatagramDemoOption ctrlState;
		vbatFlyingPercentage: 
						anARDNavigationDatagramDemoOption vbatFlyingPercentage; 
		theta: 		anARDNavigationDatagramDemoOption theta;
		phi: 			anARDNavigationDatagramDemoOption phi;
		psi: 			anARDNavigationDatagramDemoOption psi;
		altitude: 	anARDNavigationDatagramDemoOption altitude;
		vx: 			anARDNavigationDatagramDemoOption vx;
		vy: 			anARDNavigationDatagramDemoOption vy;
		vz: 			anARDNavigationDatagramDemoOption vz;
		numFrames: 	anARDNavigationDatagramDemoOption numFrames.
	^ true.
]

{ #category : #updating }
ARDNavigationDatagramDemoOption >> updateFromByteArray: aByteArray at: startByteIndex [
	| i aTag aSize |
	i := startByteIndex .
	aTag := (aByteArray unsignedShortAt: i bigEndian: false).
	aSize := (aByteArray unsignedShortAt: i + 2 bigEndian: false).
	(aTag = self class validTag & aSize = self class validSize) ifFalse: [ Transcript show: 'tag ',(aTag asString),' size', (aSize asString) ;cr. ^ false ].
	self 
		tag: 			aTag ;
		size: 			aSize ;
		ctrlState: 	(aByteArray unsignedLongAt: i + 4 bigEndian: false) ;
		vbatFlyingPercentage: 
						(aByteArray unsignedLongAt: i + 8 bigEndian: false) ;
		theta: 		(aByteArray floatAt: i + 12 bigEndian: false) ;
		phi: 			(aByteArray floatAt: i + 16 bigEndian: false) ;
		psi: 			(aByteArray floatAt: i + 20 bigEndian: false) ;
		altitude: 	(aByteArray unsignedLongAt: i + 24 bigEndian: false) ;
		vx: 			(aByteArray floatAt: i + 28 bigEndian: false) ;
		vy: 			(aByteArray floatAt: i + 32 bigEndian: false) ;
		vz: 			(aByteArray floatAt: i + 36 bigEndian: false) ;
		numFrames: 	(aByteArray unsignedLongAt: i + 40 bigEndian: false) .
	^ true
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vbatFlyingPercentage [
	"battery voltage filtered (mV)"
	^ vbatFlyingPercentage
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vbatFlyingPercentage: anInt [
	"battery voltage filtered (mV)"
	vbatFlyingPercentage := anInt
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vx [
	"estimated linear velocity"
	^ vx
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vx: aFloat [
	"estimated linear velocity"
	vx := aFloat
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vy [
	"estimated linear velocity"
	^ vy
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vy: aFloat [
	"estimated linear velocity"
	vy := aFloat
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vz [
	"estimated linear velocity"
	^ vz
]

{ #category : #accessing }
ARDNavigationDatagramDemoOption >> vz: aFloat [
	"estimated linear velocity"
	vz := aFloat
]
