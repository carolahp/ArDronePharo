"
I'm the header of an ARDNavigationDatagramDemo. I contain information about the drone's status 
"
Class {
	#name : #ARDNavigationDatagramHeader,
	#superclass : #Object,
	#instVars : [
		'header',
		'ardState',
		'seq',
		'vision'
	],
	#category : #ARDrone
}

{ #category : #validation }
ARDNavigationDatagramHeader class >> validHeader [
	^ '16r55667788'
]

{ #category : #converting }
ARDNavigationDatagramHeader >> asString [
	| cr |
	cr := Character cr asString.

	^ header asString, ':header', 	cr,  
	  ardState hexState hex asString, ':state ', cr, 
	  seq asString,  ':seq', cr, 
	  vision asString, ':vision'
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> header [

	^ header
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> header: anHex [

	header := anHex
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> initialize [
	self state: ARDState new.
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> seq [

	^ seq
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> seq: anInt [

	seq := anInt
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> size [
	"Fixed Navdata Header size in bytes, defined by ArDrone firmware"
	^ 16
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> state [
	
	^ ardState
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> state: anARDState [

	ardState := anARDState
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> stateFromHex: anHex [
	
	ardState ifNil: [ ardState new. ].
	ardState updateFromHex: anHex
]

{ #category : #converting }
ARDNavigationDatagramHeader >> stateVerbose [
	"returns drone's state as string "
	^ ardState asString
]

{ #category : #updating }
ARDNavigationDatagramHeader >> updateFrom: anARDNavigationDatagramHeader [
	"Update NavigationDatagramHeader from another object"
	(anARDNavigationDatagramHeader header = self class validHeader) 
	ifFalse: [ ^ false. ].
	self 
		header: 	anARDNavigationDatagramHeader header;
		stateFromHex: 	anARDNavigationDatagramHeader state hexState;
		seq: 		anARDNavigationDatagramHeader seq;
		vision: 	anARDNavigationDatagramHeader vision.
	^ true
]

{ #category : #updating }
ARDNavigationDatagramHeader >> updateFromByteArray: aByteArray [
	"Update NavigationDatagramHeader from a ByteArray"
	(((aByteArray unsignedLongAt: 1 bigEndian: false) hex) = self class validHeader) 
	ifFalse: [ ^ false. ].
		
	self 
		header: (aByteArray unsignedLongAt: 1 bigEndian: false) hex ;
		stateFromHex: (aByteArray unsignedLongAt: 5 bigEndian: false) ;
		seq: (aByteArray unsignedLongAt: 9 bigEndian: false) ;
		vision: (aByteArray unsignedLongAt: 13 bigEndian: false).
	
	^ true
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> vision [

	^ vision
]

{ #category : #accessing }
ARDNavigationDatagramHeader >> vision: aInt [

	vision := aInt
]
