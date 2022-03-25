"
I'm the VISION_DETECT option (tag 16). I contain information about the tags detected by the drone firmware.
"
Class {
	#name : #ARDNavigationDatagramVisionDetect,
	#superclass : #ARDNavigationDatagramOption,
	#instVars : [
		'nbDetected',
		'type',
		'xc',
		'yc',
		'width',
		'height',
		'distance',
		'orientationAngle',
		'rotation',
		'translation',
		'cameraSource',
		'dataset',
		'dataTypes'
	],
	#category : #ARDrone
}

{ #category : #validation }
ARDNavigationDatagramVisionDetect class >> validSize [
	^ 328
]

{ #category : #validation }
ARDNavigationDatagramVisionDetect class >> validTag [
	^ 16
]

{ #category : #converting }
ARDNavigationDatagramVisionDetect >> asString [
	"Returns the datagram vision detect option contents as string"
	| cr |
	cr := Character cr asString .
	^ tag 				asString, ' :tag ', cr ,
	  size 			asString, ' :size ', cr,
	  nbDetected 	asString, ' :nb Detected', cr,
	  type 			asString, ' :type', cr,
	  xc				asString, ' :xc', cr,
	  yc 				asString, ' :yc', cr,
	  width 			asString, ' :width', cr,
	  height 			asString, ' :height',cr,
	  distance 		asString, ' :distance', cr,
	  (orientationAngle collect: [ :angle | (angle isNil) ifTrue: [0]ifFalse: [angle rounded ] ])
						asString, ' :orientation angle', cr,
	  cameraSource 	asString, ' :camera source', cr.
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> cameraSource [
	^ cameraSource
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> cameraSource: anArray [
	cameraSource := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> containsDetectedTag: aDetectedTag atIndex: anIndex [
	"returns true if the vision datagram contains information about aDetectedTag (refers about tag type and camera source) in the specific index"
	
	(aDetectedTag = ARDConstant detectedTag_OR_IN_CV) 
		ifTrue: [ ^ ((self orientationAngle at: anIndex) ~= 0) & 
						(((self cameraSource at:anIndex) = ARDConstant videoChannel_ZAP_CHANNEL_VERT) | 
						((self cameraSource at:anIndex) = 2))]. "the camera source = 2 case, occurs when the drone is in 'hover on top of oriented roundel' flying mode and detects the oriented roundel tag in its vertical camera"
	 
	(aDetectedTag = ARDConstant detectedTag_SH_IN_CH) 
		ifTrue: [ ^ ((self orientationAngle at: anIndex) = 0) & 
						((self cameraSource at:anIndex) = ARDConstant videoChannel_ZAP_CHANNEL_HORI )].
	
	Exception new: 'Detected tag type requested doesnt exists' signal.
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> distance [
	^ distance
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> distance: anArray [
	distance := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> height [
	^ height
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> height: anArray [
	height := anArray
]

{ #category : #initialization }
ARDNavigationDatagramVisionDetect >> initialize [
	super initialize.
	nbDetected := 0.
	dataTypes := 'HHIIIIIIIIIIIIIIIIIIIIIIIIIffffIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIffffIIII'.
	dataset 				:= Array new: dataTypes size.
	type 					:= Array new: 4.
	xc 						:= 	Array new: 4.
	yc 						:= 	Array new: 4.
	width 					:= Array new: 4.	
	height 				:= Array new: 4.	
	distance 				:= Array new: 4.
	orientationAngle 	:= Array new: 4.
	cameraSource 		:= Array new: 4.
	
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> nbDetected [
	^ nbDetected
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> nbDetected: anInt [
	nbDetected := anInt
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> orientationAngle [
	^ orientationAngle
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> orientationAngle: anArray [
	orientationAngle := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> rotation [
	^ rotation
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> rotation: anArray [
	rotation := anArray
]

{ #category : #private }
ARDNavigationDatagramVisionDetect >> tagsDetectedFrom: anArray [
	self nbDetected = 0
		ifTrue: [ ^ { } ].
	^ anArray copyFrom: 1 to: self nbDetected.
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> translation [
	^ translation
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> translation: anArray [
	translation := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> type [

	^ type
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> type: anArray [

	type := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> unpackByteArray: aByteArray from: anArray startAt: startByteIndex [
	| b r |
	r := 1.
	b := startByteIndex.
	anArray do: [ :each |
		(each = $I) 
			ifTrue: [ dataset at: r put: (aByteArray unsignedLongAt: b bigEndian: false). b := b+4. ].
		(each = $H) 
			ifTrue: [ dataset at: r put: (aByteArray unsignedShortAt: b bigEndian: false). b := b+2. ].
		(each = $f) 
			ifTrue: [ dataset at: r put: (aByteArray floatAt: b bigEndian: false). b := b+4. ].
		r := r+1.
	].
]

{ #category : #updating }
ARDNavigationDatagramVisionDetect >> updateFrom: anARDNavigationDatagramVisionDetect [
	(anARDNavigationDatagramVisionDetect tag asInteger = self class validTag &
	anARDNavigationDatagramVisionDetect size asInteger = self class validSize)
	ifFalse: [ ^ false ].
	
	self 
		tag: 			anARDNavigationDatagramVisionDetect tag;
		size: 			anARDNavigationDatagramVisionDetect size;
		nbDetected: 	anARDNavigationDatagramVisionDetect nbDetected;
	 	type: 			anARDNavigationDatagramVisionDetect type;
	 	xc:    		anARDNavigationDatagramVisionDetect xc;
	 	yc:    		anARDNavigationDatagramVisionDetect yc; 
	 	width: 		anARDNavigationDatagramVisionDetect width;
	 	height: 		anARDNavigationDatagramVisionDetect height; 
	 	distance:  	anARDNavigationDatagramVisionDetect distance;
	 	orientationAngle: 
						anARDNavigationDatagramVisionDetect orientationAngle;
	 	rotation:  	anARDNavigationDatagramVisionDetect rotation;
	 	translation: anARDNavigationDatagramVisionDetect translation;
	 	cameraSource:anARDNavigationDatagramVisionDetect cameraSource.
	^ true.
]

{ #category : #updating }
ARDNavigationDatagramVisionDetect >> updateFromByteArray: aByteArray at: startByteIndex [
	"unpack ByteArray info into the instance variable 'dataset'"
	self unpackByteArray: aByteArray from: dataTypes startAt: startByteIndex .
	((dataset at:1) = self class validTag & (dataset at:2) = self class validSize) 
	ifFalse: [ Transcript show: 'tag ',((dataset at:1) asString),' size', ((dataset at:2) asString) ;cr.^ false ].
	self 	tag: 			(dataset at:1);
			size: 			(dataset at:2);
			nbDetected: 	(dataset at:3).
	1 to: 4 do: [ :i | self type     at: i put: ( dataset at: i+3) ].
	1 to: 4 do: [ :i | self xc 	  	 at: i put: ( dataset at: i+7) ].
	1 to: 4 do: [ :i | self yc 	  	 at: i put: ( dataset at: i+11) ].
	1 to: 4 do: [ :i | self width  	 at: i put: ( dataset at: i+15) ].
	1 to: 4 do: [ :i | self height 	 at: i put: ( dataset at: i+19) ].
	1 to: 4 do: [ :i | self distance at: i put: ( dataset at: i+23) ].
	1 to: 4 do: [ :i | self orientationAngle at: i put: ( dataset at: i+27) ].
	"self	rotation:  	(Array new: 4).(1 to: 4) do: [ :i | self rotation at: i put: (Array new: 9).
													(1 to: 9) do: [ :j |(self rotation at: i) at:j put: (dataset at: (i-1)*9+j+31)]].
	self	translation: 	(Array new: 4).(1 to: 4) do: [ :i | self translation at: i put: (Array new: 3).
													(1 to: 3) do: [ :j |(self translation at: i) at:j put: (dataset at: (i-1)*3+j+67)]]."
	1 to: 4 do: [ :i | self cameraSource at: i put: ( dataset at: i+79) ].
	^ true.
	
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> width [
	^ width
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> width: anArray [
	width := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> xc [
	^ xc
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> xc: anArray [
	xc := anArray
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> yc [
	^ yc
]

{ #category : #accessing }
ARDNavigationDatagramVisionDetect >> yc: anArray [
	yc := anArray
]
