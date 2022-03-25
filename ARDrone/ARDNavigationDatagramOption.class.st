"
I'm an abstract class that represent a Datagram Option
"
Class {
	#name : #ARDNavigationDatagramOption,
	#superclass : #Object,
	#instVars : [
		'tag',
		'size'
	],
	#category : #ARDrone
}

{ #category : #validation }
ARDNavigationDatagramOption class >> nextOptionTagIn: aByteArray at: anIndex [
	"returns the tag of the option encoded in the bytearray at the index anIndex"
	^ aByteArray unsignedShortAt: anIndex bigEndian: false
]

{ #category : #validation }
ARDNavigationDatagramOption class >> validSize [
	^ self subclassResponsibility 
]

{ #category : #validation }
ARDNavigationDatagramOption class >> validTag [
	^ self subclassResponsibility 
]

{ #category : #converting }
ARDNavigationDatagramOption >> asString [
	
	self subclassResponsibility 
]

{ #category : #accessing }
ARDNavigationDatagramOption >> size [
	"size of this structure"
	^ size
]

{ #category : #accessing }
ARDNavigationDatagramOption >> size: anInt [
	"size of this structure"
	size := anInt
]

{ #category : #accessing }
ARDNavigationDatagramOption >> tag [
	"Navdata block ('option') identifier"
	^ tag
]

{ #category : #accessing }
ARDNavigationDatagramOption >> tag: anInt [
	"Navdata block ('option') identifier"
	tag := anInt
]

{ #category : #updating }
ARDNavigationDatagramOption >> updateFrom: anObject [

	self subclassResponsibility. 
]

{ #category : #updating }
ARDNavigationDatagramOption >> updateFromByteArray: aByteArray at: startByteIndex [

	self subclassResponsibility. 
]
