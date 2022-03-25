"
I set up an interface for communicating via UDP with the drone
I'm designed for being used privatly inside this ArDrone's API, but if you want to know how I work, here it is:

API messages:
	-- ARDAdapterUDP class >> withPort:  droneAddress:  isMulticast:  delayInterval: 
			-> Returns a new instance of this class
	- ARDAdapterUDP >> send:   						
			->Sends a message
	- ARDAdapterUDP >> receive 					
			-> Receives a single message
	- ARDAdapterUDP >> receiveWithin:  onTimeout:  	
			-> Tries to receive a message during a time interval


Instance variables:
	- socket <Socket>: UDP socket used to send and receive
	- droneAddress <IP address>: drone's IP address 
	- delayInterval <Integer>: time interval between messages sent
	- isMulticast <Boolean>: tells wether the socket is multicast or not
	- mutex <Mutex>: used to ensure the usage of the command send is exclusive. (only one process can use this adapter to send messages at the time)
"
Class {
	#name : #ARDAdapterUDP,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'socket',
		'droneAddress',
		'delayInterval',
		'isMulticast',
		'mutex',
		'recipientByteArray'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDAdapterUDP class >> withARDrone: anARDrone port: aPort isMulticast: aBoolean delayInterval: anInterval [ 
	"Returns an instance of ARDAdapterUDP. The arguments types must be:
	- aPort <Integer>
	- anIPAddress <String>
	- aBoolean <Boolean>
	- anInterval <Integer>"
	
	^ (self new) 
			arDrone: anARDrone;
			droneAddress: ARDConstant address_DRONE;
			isMulticast: aBoolean;
			socket: (Socket newUDP setPort: aPort);
			delayInterval: anInterval .
]

{ #category : #accessing }
ARDAdapterUDP >> arDrone [
	"Sets the ARDrone instance for which this Adapter UDP was created"
	^ arDrone
]

{ #category : #accessing }
ARDAdapterUDP >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Adapter UDP was created"
	arDrone := anARDrone
]

{ #category : #receiving }
ARDAdapterUDP >> closeAndDestroy [

	socket closeAndDestroy.
]

{ #category : #accessing }
ARDAdapterUDP >> delayInterval [
	
	^ delayInterval
]

{ #category : #accessing }
ARDAdapterUDP >> delayInterval: anInt [
	
	delayInterval := anInt
]

{ #category : #accessing }
ARDAdapterUDP >> droneAddress [
	
	^ droneAddress 
]

{ #category : #accessing }
ARDAdapterUDP >> droneAddress: aString [
	
	droneAddress := NetNameResolver addressForName: aString
]

{ #category : #initialization }
ARDAdapterUDP >> initialize [
	super initialize .
	mutex := Mutex new.
	delayInterval := 30 .
	recipientByteArray := ByteArray new: 4096.
	
	
]

{ #category : #accessing }
ARDAdapterUDP >> isMulticast [
	
	^ isMulticast
]

{ #category : #accessing }
ARDAdapterUDP >> isMulticast: aBoolean [
	
	^ aBoolean
]

{ #category : #receiving }
ARDAdapterUDP >> receive [
	"Receives a single message using the socket, and returns its content in a ByteArray buffer. It returns 0 if nothing was received."
	| buffer received |
	"buffer := ByteArray new: 4096."
	buffer := recipientByteArray.
	received := 0.
	[received := socket receiveUDPDataInto: buffer.] 
		on: Exception 
		do: [ ^ 0 ].
	
	((received at: 1) > 0) 
			ifTrue: [
				^ buffer .
			]
			ifFalse: [ 
				^ 0 .
			].
	 
]

{ #category : #receiving }
ARDAdapterUDP >> receiveWithin: aTimeInterval onTimeout: aBlock [
	"Tries to receive a message in its socket for aTimeInterval time. Excecutes aBlock if timeout is reached."
	| received |
	[ [true] whileTrue: [ 
			received := self receive.
			(received = 0) 
				ifFalse: [^ received ].
		]
	] valueWithin: aTimeInterval onTimeout: aBlock.
	
]

{ #category : #sending }
ARDAdapterUDP >> send: message [
	"Sends a message via UDP, using its socket (already initialized with port and host). The usage of this function is exclusive, so it is protected by a mutex.
	Arguments:
	- messages <ARDCommand> or <String> (properly formated string)"
	
	mutex critical: [ 
		(message isMemberOf: ARDCommand) 
			ifTrue: [ message sequenceNumber: arDrone nextSequenceNumber.
						(message prefix = 'AT*COMWDG' | (message prefix = 'AT*CTRL')) 
							ifFalse: ["Transcript show: (message asString, Time now asString); cr"].
						(message prefix = 'AT*PCMD') 
							ifTrue: [Transcript show: (message asString, Time now asString); cr]  ]
			ifFalse: [ "Transcript show: message asString; cr" ].
		socket 
			 	sendData: message asByteArray 
			 	toHost: droneAddress
			 	port: socket port.
		(Delay forMilliseconds: delayInterval) wait.
	].
	^ true.
]

{ #category : #accessing }
ARDAdapterUDP >> socket [
	
	^ socket
]

{ #category : #accessing }
ARDAdapterUDP >> socket: anUDPSocket [
	
	socket := anUDPSocket 
]
