"
I'm the ARDrone's navdata manager, my main responsibility is to receive navigation data broadcasted by the real drone over the network. I use an ARDAdapterUDP.

IMPORTANT: It's the user's responsibility to terminate each instance of this class using the message ARDNavdataManager>>terminate (this message is called from ARDrone terminateSession). If an instance is not terminated, two processes will keep running in background

I run two processes:
	- The receiverProcess receives navdata permanently, and can excecute a Block using the datagram received as the block's argument.
	- the keepAliveProcess that sends messages to the real drone, to ensure the connection is kept alive.


API messages:
	- ARDNavdataManager class >> withARDrone:
			-> returns an instance of the class.
		
	- ARDNavdataManager >> receiveAndDo:
			-> uses aBlock as argument. It terminates the current receiverProcess and redefines it, so it excecutes aBlock each time a navigation datagram is received. The block received as argumen must use the datagram as a parameter. 
	
	- ARDNavdataManager >> stopReceiving 
			-> finishes the process that receives navdata (receiverProcess)

	- ARDNavdataManager >> terminate		
			-> finishes all processes associated with this instance.

Example:
	If I want to show the received navdata in the Transcript, I should do:
	anARDNavdataManager receiveAndDo: [ :datagram | Transcript show: datagram asString ]			

Instance variables: 
	- arDrone <ARDrone>
	- receiverProcess <Process>
	- KeepAliveProcess <Process>
"
Class {
	#name : #ARDNavdataManager,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'receiverProcess',
		'suspendProcess',
		'terminateProcess',
		'lastDatagramReceived',
		'previousDatagramReceived'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDNavdataManager class >> announceStateChangesFrom: lastARDNavigationDatagram and: previousARDNavigationDatagram using: anAnnouncer [
"Announces (through the arDrone's announcer instance) the drone's state changes (if happened), based on the information carried in the navigation datagrams (navdata) sent by the drone"
	| lastND prevND |
	
	anAnnouncer announce: DroneNavdataPacketReceived.
	lastND := lastARDNavigationDatagram.
	prevND := previousARDNavigationDatagram.
	
	(lastND containsData not | 
	 prevND containsData not) 
	ifTrue: [ ^ 0 ].
	"Announce: DroneTookOff"
	(lastND droneIsFlying & (prevND droneIsFlying not))
	ifTrue: [ anAnnouncer announce: DroneTookOff. Transcript show: 'TookOff';cr. ].
	
	"Announce: DroneLanded"
	((lastND droneIsFlying not) & prevND droneIsFlying)
	ifTrue: [ anAnnouncer announce: DroneLanded. Transcript show: 'Landed';cr.  ].
		
	
]

{ #category : #'instance creation' }
ARDNavdataManager class >> withARDrone: anARDrone [
	"Returns a Navdata manager for receiving navigation data from anARDrone"
	^ (self new)
			arDrone: anARDrone
]

{ #category : #accessing }
ARDNavdataManager >> arDrone [
	"Returns the ARDrone instance for which this Navdata Manager was created"
	^ arDrone
	
]

{ #category : #accessing }
ARDNavdataManager >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Navdata Manager was created"
	arDrone := anARDrone
	
]

{ #category : #accessing }
ARDNavdataManager >> connected [
	
	^ true
]

{ #category : #api }
ARDNavdataManager >> hasReceivedNavdata [

	^ self lastDatagramReceived containsData	
	
]

{ #category : #api }
ARDNavdataManager >> initialize [
	super initialize.
	suspendProcess := true.
	terminateProcess := false.
	lastDatagramReceived := ARDNavigationDatagramDemo new.
	previousDatagramReceived := ARDNavigationDatagramDemo new.
	
	"starts receiving navdata"
	receiverProcess := self receiverProcessCallback: [ :datagram | ].

]

{ #category : #api }
ARDNavdataManager >> lastDatagramReceived [
	
	^ lastDatagramReceived
]

{ #category : #private }
ARDNavdataManager >> previousDatagramReceived [
	
	^ previousDatagramReceived
]

{ #category : #private }
ARDNavdataManager >> receive [
	"Receives a navigation datagram from the drone, and uses it to update its lastNavigationDatagram. If no datagram was received returns nil; otherwise returns the datagram"
	| datagram  buffer  |
	buffer := arDrone navdataAdapter receive.
	
	( buffer = 0 )  
		ifFalse: [  self previousDatagramReceived updateFrom: self lastDatagramReceived.
						(self lastDatagramReceived updateFromByteArray: buffer)
						ifTrue: [
							"Transcript show: 'received';cr."
							datagram := self lastDatagramReceived.
							self class 
								announceStateChangesFrom: self lastDatagramReceived 
								and: self previousDatagramReceived 
								using: arDrone announcer .
							].
						 ].
	^ datagram.
]

{ #category : #api }
ARDNavdataManager >> receiverProcessCallback: aBlock [
	"Redefines the receiverProcess, so it includes the callback aBlock inside its loop.
	The receiverProcess excecutes an infinite loop, in each cycle receives one navigation packet."
	receiverProcess ifNotNil: [ receiverProcess terminate ].
	
	receiverProcess :=
	[[ | datagram |
		suspendProcess ifTrue: [ Processor activeProcess suspend ].	
		datagram := self receive .
		(datagram isNotNil) 
			ifTrue: [ 
				aBlock value: datagram ].
		terminateProcess ifTrue: [ Processor activeProcess terminate ].
		(Delay forMilliseconds: 20) wait.
	] repeat ] newProcess.
	^ receiverProcess.
]

{ #category : #api }
ARDNavdataManager >> resume [
	"Resumes all processes associated with this instance."
	suspendProcess := false.
	receiverProcess resume.

]

{ #category : #api }
ARDNavdataManager >> stopReceiving [
	"Finishes the process that receives navdata."
	terminateProcess := true
]

{ #category : #api }
ARDNavdataManager >> suspend [
	"Suspends all processes associated with this instance."
	suspendProcess := true

]

{ #category : #api }
ARDNavdataManager >> terminate [
	"Finishes all processes associated with this instance."
	receiverProcess terminate.

]
