"
I'm an analyst for the Vision Detect data. I provide elaborated information about the tags detected by the drone. 
"
Class {
	#name : #ARDVisionDetectAnalyst,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'lastVisionDatagram',
		'detectedTags'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDVisionDetectAnalyst class >> withARDrone: anARDrone [
	"Returns a visionDetectAnalyst analizing the vision detect information received from the drone via navdata"
	^ (self new)
			arDrone: anARDrone
]

{ #category : #accessing }
ARDVisionDetectAnalyst >> arDrone [

	^ arDrone
]

{ #category : #accessing }
ARDVisionDetectAnalyst >> arDrone: anARDrone [

	arDrone := anARDrone.
	self unsubscribe.
	self subscribe.
]

{ #category : #'accessing-parameters' }
ARDVisionDetectAnalyst >> arrayLength [
	"size of the visionDatagrams array (used for storing the last n datagrams received from the drone"
	^ 3
]

{ #category : #initialization }
ARDVisionDetectAnalyst >> destroy [
	self unsubscribe 
]

{ #category : #'tags detection' }
ARDVisionDetectAnalyst >> detectedTag: aDetectedTagType [
	"Returns the ARDDetectedTag object that represent the detected tag of the type and from the camera specified by the argument aDetectedType. 
	aDetectedTagType is an enumeration, it is defined in ARDConstant. Its values can be:
	- detectedTag_OR_IN_CV: Oriented roundel detected in vertical camera
	- detectedTag_SH_IN_CH: Shell tag detected in horizontal camera "
	^ [(detectedTags select: 
			[ :dt | dt detectedTagType = aDetectedTagType ]) 
		at:1
		] on: SubscriptOutOfBounds do: [ ^ nil ]
	
]

{ #category : #initialization }
ARDVisionDetectAnalyst >> initialize [
	lastVisionDatagram := ARDNavigationDatagramVisionDetect new.

	detectedTags := 
		{ "for OR_IN_CV (Oriented roundel in vertical camera)" 
			ARDDetectedTag new detectedTagType: 
				ARDConstant detectedTag_OR_IN_CV.
			"for SH_IN_CH (Shell in horizontal camera)" 
			ARDDetectedTag new detectedTagType: 
				ARDConstant detectedTag_SH_IN_CH }
	
]

{ #category : #'tags detection' }
ARDVisionDetectAnalyst >> nTagsDetected [
	"returns the number of tags detected informed by the last datagram received"
	^ lastVisionDatagram nbDetected .
	
]

{ #category : #subscription }
ARDVisionDetectAnalyst >> subscribe [
	self arDrone announcer 
		subscribe: DroneNavdataPacketReceived
		do: [ self updateFromVisionDatagram: (arDrone lastNavdataPacketReceived options at:2). ].
]

{ #category : #subscription }
ARDVisionDetectAnalyst >> unsubscribe [
	self arDrone announcer unsubscribe: DroneNavdataPacketReceived
		
]

{ #category : #private }
ARDVisionDetectAnalyst >> updateFromVisionDatagram: anARDNavigationDatagramVisionDetect [
	| dg |
	dg := anARDNavigationDatagramVisionDetect.
	lastVisionDatagram := dg.
	detectedTags 
		do: [ :each | each detected: false].
	
	1 to: dg nbDetected 
		do: [ :i |
				detectedTags do: 
				[ :dt |
					(dg
						containsDetectedTag: (dt detectedTagType) 
						atIndex: i)
						ifTrue: [ dt updateFrom: dg index: i ]]]
]
