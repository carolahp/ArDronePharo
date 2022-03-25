"
I represent a tag detected in a specific camera by the drone firmware, and informed via navdata.  I contain the logic to answer questions such as if I'm centered, etc.
"
Class {
	#name : #ARDDetectedTag,
	#superclass : #Object,
	#instVars : [
		'detected',
		'type',
		'xc',
		'yc',
		'width',
		'height',
		'distance',
		'orientationAngle',
		'cameraSource',
		'lastPositions',
		'count',
		'lastDetections',
		'detectedTagType'
	],
	#category : #ARDrone
}

{ #category : #calculating }
ARDDetectedTag class >> anglesAreEquivalent: angle1 and: angle2 tolerance: toleranceFactor [
	^ ((((180 + (angle1 - angle2) abs) % 360) - 180) abs) < (toleranceFactor * 360).
	
]

{ #category : #accessing }
ARDDetectedTag >> cameraSource [
	^ cameraSource
]

{ #category : #accessing }
ARDDetectedTag >> cameraSource: anInt [
	cameraSource := anInt
]

{ #category : #'type check' }
ARDDetectedTag >> checkConsistency [
	self detectedTagType = ARDConstant detectedTag_OR_IN_CV 
		ifTrue: [ ^ (self isOR & self inCV) ].
	self detectedTagType = ARDConstant detectedTag_SH_IN_CH 
		ifTrue: [ ^ (self isSH & self inCH) ].
	Exception new: 'Incorrect detected tag type' signal.
]

{ #category : #accessing }
ARDDetectedTag >> currentIndex [
	^ (count % (self registersSize - 1) + 1)
]

{ #category : #accessing }
ARDDetectedTag >> detected [
	^ detected = 1
]

{ #category : #accessing }
ARDDetectedTag >> detected: aBoolean [
	detected := aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ]
]

{ #category : #accessing }
ARDDetectedTag >> detectedTagType [
	"aDetectedTagType is an enumeration from ARDConstant >> detectedTag_xxx"
	^ detectedTagType
]

{ #category : #accessing }
ARDDetectedTag >> detectedTagType: aDetectedTagType [
	"aDetectedTagType is an enumeration from ARDConstant >> detectedTag_xxx"
	detectedTagType := aDetectedTagType 
]

{ #category : #'weighted values' }
ARDDetectedTag >> detectedWeighted [
	^ ((((lastDetections 
			collect: [ :each | each]) 
			inject: 0 
			into: [:sum :total | sum + total]) / (self registersSize)) rounded) = 1
]

{ #category : #accessing }
ARDDetectedTag >> distance [
	^ distance
]

{ #category : #accessing }
ARDDetectedTag >> distance: anInt [
	distance := anInt
]

{ #category : #accessing }
ARDDetectedTag >> height [
	^ height
]

{ #category : #accessing }
ARDDetectedTag >> height: anInt [
	height := anInt
]

{ #category : #'type check' }
ARDDetectedTag >> inCH [
	"returns true if tag is detected in the Horizontal camera"
	^ self cameraSource = ARDConstant videoChannel_ZAP_CHANNEL_HORI 
]

{ #category : #'type check' }
ARDDetectedTag >> inCV [
	"returns true if tag is detected in the Vertical Camera"
	^ self cameraSource = ARDConstant videoChannel_ZAP_CHANNEL_VERT 
]

{ #category : #initialization }
ARDDetectedTag >> initialize [
	orientationAngle := -1.
	detected := 0.
	count := 0.
	lastPositions := Array new: self registersSize.
	lastDetections := Array new: self registersSize.
	 
	1 to: self registersSize 
		do: [:i | lastDetections at: i put: 0.
					 lastPositions at: i put: ARDPoint new].

	
]

{ #category : #queries }
ARDDetectedTag >> isAtDistance: aDistance tolerance: aTolerance [

	^ (self position z - aDistance) abs <= (aTolerance * aDistance)
]

{ #category : #queries }
ARDDetectedTag >> isCentered [
	"returns true if the tag is in the center of the camera image (considering a tolerance of 15%)"

	^ (self isCenteredWithTolerance: 0.15)  
]

{ #category : #queries }
ARDDetectedTag >> isCenteredInXWithTolerance: aToleranceFactor [
	"aToleranceFactor must be a float in [0, 1["

	^ (self position x - 500) abs <= (aToleranceFactor * 500)
]

{ #category : #queries }
ARDDetectedTag >> isCenteredInYWithTolerance: aToleranceFactor [
	"aToleranceFactor must be a float in [0, 1["

	^ (self position y - 500) abs <= (aToleranceFactor * 500)
]

{ #category : #queries }
ARDDetectedTag >> isCenteredWithTolerance: aToleranceFactor [
	"aToleranceFactor must be a float in [0, 1["

	^ (self isCenteredInXWithTolerance: aToleranceFactor) &
	(self isCenteredInYWithTolerance: aToleranceFactor) 
]

{ #category : #'type check' }
ARDDetectedTag >> isOR [
	"returns true if the informed type matches the OrientedRoundel type or the BW Cocarde type. 
	The orientation angle is used as reference because the drone fails to inform the tag type when the detection mode is Multidetection"
	^ (self orientationAngle ~= 0)
]

{ #category : #queries }
ARDDetectedTag >> isOriented [
	^ self isOrientedIn: 0 tolerance: 0.1 
]

{ #category : #queries }
ARDDetectedTag >> isOrientedIn: anAngle tolerance: aToleranceFactor [
	"anAngle must be sexagesimal degrees. aTolerance must be a float in [0, 1["
	^ ((self isOR) &
	  (self orientationAngle > 0)) 
			and: [ (self class 
						anglesAreEquivalent:  (self orientationAngle)
						and:  anAngle
						tolerance: aToleranceFactor) ]  
	  
]

{ #category : #'type check' }
ARDDetectedTag >> isSH [
	"returns true if the informed type is Shell type"
	^ (self orientationAngle = 0)
]

{ #category : #queries }
ARDDetectedTag >> offsetInDistance: desiredDistance [
	"returns a float in [-1,1] that represents how far is the tag from the center of the camera according to the Y axis, considering 0 the center, -1 the top and 1 the bottom"
	^ ((self position z - desiredDistance ) / desiredDistance) asFloat
]

{ #category : #queries }
ARDDetectedTag >> offsetInX [
	"returns a float in [-1,1] that represents how far is the tag from the center of the camera according to the X axis, considering 0 the center, -1 the left side and 1 the right side"
	^ (self position x - 500) / 500
]

{ #category : #queries }
ARDDetectedTag >> offsetInY [
	"returns a float in [-1,1] that represents how far is the tag from the center of the camera according to the Y axis, considering 0 the center, -1 the top and 1 the bottom"
	^ ((self position y - 500) / 500) asFloat
]

{ #category : #accessing }
ARDDetectedTag >> orientationAngle [
	^ orientationAngle
]

{ #category : #accessing }
ARDDetectedTag >> orientationAngle: aFloat [
	orientationAngle := aFloat
]

{ #category : #accessing }
ARDDetectedTag >> position [
	^ lastPositions at: self currentIndex 
]

{ #category : #accessing }
ARDDetectedTag >> registersSize [
	^ 3
]

{ #category : #accessing }
ARDDetectedTag >> type [
	^ type
]

{ #category : #accessing }
ARDDetectedTag >> type: aTagType [
	type := aTagType
]

{ #category : #updating }
ARDDetectedTag >> updateFrom: anARDNavigationDatagramVisionDetect index: anIndex [
	| dg i |
	i := anIndex.
	dg := anARDNavigationDatagramVisionDetect.
	count := count + 1.
	xc 			:= dg xc 			at:i.
	yc 			:= dg yc 			at:i.
	distance 	:= dg distance 	at:i.
	orientationAngle := dg orientationAngle at:i.
	cameraSource := dg cameraSource at:i.
	
	(cameraSource = 2) ifTrue: [ cameraSource := 1 ]. "Camera source is 2 for oriented roundel when it is detected by the vertical camera wile the drone is in flying mode 'hover on top of oriented roundel"
	(lastPositions at: self currentIndex) 
		x: xc
		y: yc
		z: distance.
		
	self detected: true.
	self checkConsistency 
		ifFalse: [ NotYetImplemented new signal  ]
		
	

]

{ #category : #accessing }
ARDDetectedTag >> width [
	^ width
]

{ #category : #accessing }
ARDDetectedTag >> width: anInt [
	width := anInt
]

{ #category : #accessing }
ARDDetectedTag >> xc [
	^ xc
]

{ #category : #accessing }
ARDDetectedTag >> xc: anInt [
	xc := anInt
]

{ #category : #accessing }
ARDDetectedTag >> yc [
	^ yc
]

{ #category : #accessing }
ARDDetectedTag >> yc: anInt [
	yc := anInt
]
