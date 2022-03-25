Class {
	#name : #ARDAdapterTCP,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'socket',
		'port',
		'droneAddress'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDAdapterTCP class >> withARDrone: anARDrone port: aPort [
	"Returns an instance of ARDAdapterUDP. The arguments types must be:
	- aPort <Integer>
	- anIPAddress <String>
	- aBoolean <Boolean>
	- anInterval <Integer>"
	
	^ (self new) 
			arDrone: anARDrone;
			droneAddress: ARDConstant address_DRONE;
			port: aPort.
]

{ #category : #accessing }
ARDAdapterTCP >> arDrone [
	"Sets the ARDrone instance for which this Adapter UDP was created"
	^ arDrone
]

{ #category : #accessing }
ARDAdapterTCP >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Adapter UDP was created"
	arDrone := anARDrone
]

{ #category : #accessing }
ARDAdapterTCP >> closeAndDestroy [

	socket ifNotNil: [ socket closeAndDestroy ] .
]

{ #category : #accessing }
ARDAdapterTCP >> connect [
	
	[ socket := Socket newTCP.
	socket 
		connectTo: (self droneAddress) port: (self port) waitForConnectionFor: 50 ]
		on: Exception 
		do:  [^ false].
	^ true
]

{ #category : #accessing }
ARDAdapterTCP >> droneAddress [
	
	^ droneAddress 
]

{ #category : #accessing }
ARDAdapterTCP >> droneAddress: aString [
	
	droneAddress := NetNameResolver addressForName: aString
]

{ #category : #'as yet unclassified' }
ARDAdapterTCP >> isConnected [
	^ socket isConnected
]

{ #category : #accessing }
ARDAdapterTCP >> port [
	
	^ port
]

{ #category : #accessing }
ARDAdapterTCP >> port: anInt [
	
	port := anInt
]

{ #category : #accessing }
ARDAdapterTCP >> receive [
	"Receives a single message using the socket, and returns its content in a ByteArray buffer. It returns 0 if nothing was received."
	| buffer received |
	buffer := ByteArray new: 8000.
	received := 0.
	received := socket receiveDataTimeout: (self receiveTimeout * 1000) into: buffer.

	(received > 0) 
			ifTrue: [
				^ buffer .
			]
			ifFalse: [ 
				^ 0 .
			].
	 
	
]

{ #category : #accessing }
ARDAdapterTCP >> receiveTimeout [
	^ 400
	 
	
]

{ #category : #accessing }
ARDAdapterTCP >> socket [
	
	^ socket
]

{ #category : #accessing }
ARDAdapterTCP >> socket: anUDPSocket [
	
	socket := anUDPSocket 
]
