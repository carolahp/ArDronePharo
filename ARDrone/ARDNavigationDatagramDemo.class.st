"
I'm a navdata block when the drone is set to Demo Mode. I contain information about the drone status. This information is received via the navdata incoming stream from the real drone.
"
Class {
	#name : #ARDNavigationDatagramDemo,
	#superclass : #Object,
	#instVars : [
		'header',
		'options',
		'containsData'
	],
	#category : #ARDrone
}

{ #category : #converting }
ARDNavigationDatagramDemo >> asString [
	| cr |
	cr := Character cr asString .
	self containsData ifFalse: [ ^ 'No data',cr ].
	^ header asString, cr, cr,
	  (options at:1) asString, cr, cr,
	  (options at:2) asString. 
]

{ #category : #converting }
ARDNavigationDatagramDemo >> asStringVerbose: showExplanations [
	| cr |
	cr := Character cr asString .
	self containsData ifFalse: [ ^ 'No data',cr ].
	^ header asString, cr, cr, 
	  (showExplanations 
		ifTrue: [header state asStringVerbose] 
		ifFalse: [header state asString]), cr,  
	  (options at:1) asString, cr, cr,
	  (options at:2) asString. 
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> containsData [

	^ containsData
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> containsData: aBoolean [

	containsData := aBoolean
]

{ #category : #api }
ARDNavigationDatagramDemo >> droneAltitude [
	"returns the current altitude (as an int in centimeters)"
	^ (self options at:1) altitude
]

{ #category : #api }
ARDNavigationDatagramDemo >> droneBatteryLevel [
	"returns the remaining battery percentage as an integer"
	^ (self options at:1) vbatFlyingPercentage.
]

{ #category : #api }
ARDNavigationDatagramDemo >> droneIsFlying [
	"returns true if the drone is flying"
	^ self header state flyMask = 1
]

{ #category : #api }
ARDNavigationDatagramDemo >> droneIsInEmergencyState [
	"returns true if the drone is in emergency state"
	^ self header state emergencyLanding = 1
]

{ #category : #api }
ARDNavigationDatagramDemo >> droneLowBattery [
	"returns true if the battery level is too low"
	self header state vBatLow ifNil: [ ^ false ].
	^ self header state vBatLow = 1
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> header [

	^ header
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> header: aDatagramHeader [
	
	header := aDatagramHeader
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> initialize [
	super initialize.
	self containsData: false.
	header  := ARDNavigationDatagramHeader new.
	options := { ARDNavigationDatagramDemoOption new. 
					 ARDNavigationDatagramVisionDetect new }
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> options [
	
	^ options 
]

{ #category : #accessing }
ARDNavigationDatagramDemo >> options: anArray [
	
	options := anArray 
]

{ #category : #updating }
ARDNavigationDatagramDemo >> updateFrom: anARDNavigationDatagramDemo [
	
	(anARDNavigationDatagramDemo containsData) ifFalse: [ ^ false ].
	 
	(header updateFrom: anARDNavigationDatagramDemo header) ifFalse: [ ^ false  ] .
	((options at:1) updateFrom:  (anARDNavigationDatagramDemo options at:1)) ifFalse: [^ false ].
	((options at:2) updateFrom:  (anARDNavigationDatagramDemo options at:2)) ifFalse: [ ^ false ].
	self containsData: true.
	^ true


]

{ #category : #updating }
ARDNavigationDatagramDemo >> updateFromByteArray: aByteArray [
	| nextTag |
	"update header"
	(header updateFromByteArray: aByteArray) 
		ifFalse: [ "Transcript show: 'Header';cr."^ false ] .
	"update options demo tag 0"
	"nextTag := ARDNavigationDatagramOption nextOptionTagIn: aByteArray at: (1 + header size).
	(nextTag = 0) ifTrue: [ 
		 ]. "
	((options at:1) updateFromByteArray: aByteArray at: (1 + header size)) 
	ifTrue: [ 
		"update options vision tag 16"
		(options at:2) updateFromByteArray: aByteArray at: (1 + (header size) + ((options at:1) size)) ].
	self containsData: true.
	^ true


]
