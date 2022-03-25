Class {
	#name : #ARDConfigurationManager,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'adapterTCP',
		'configuration',
		'configRetrievedAnnounced',
		'retrieverProcess',
		'suspendProcess',
		'terminateProcess',
		'timeLastUpdate'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDConfigurationManager class >> withARDrone: anARDrone [
	"Returns an ARDCommandManager instance for managing sending AT commands to the drone. 
	The argument type must be:
	- anARDrone <ARDrone>"
	^ (self new)
		arDrone: anARDrone;
		adapterTCP: (ARDAdapterTCP withARDrone: anARDrone port: ARDConstant port_CONFIGURATION )
]

{ #category : #accessing }
ARDConfigurationManager >> adapterTCP [

	^ adapterTCP
	
]

{ #category : #accessing }
ARDConfigurationManager >> adapterTCP: anARDAdapterTCP [

	adapterTCP := anARDAdapterTCP
	
]

{ #category : #accessing }
ARDConfigurationManager >> arDrone [
	"Returns the ARDrone instance for which this Command Manager was created"
	^ arDrone
]

{ #category : #accessing }
ARDConfigurationManager >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Command Manager was created"
	arDrone := anARDrone
	
]

{ #category : #accessing }
ARDConfigurationManager >> configRetrievedAnnounced [

	^ configRetrievedAnnounced ifNil: [ configRetrievedAnnounced := false ]
	
]

{ #category : #accessing }
ARDConfigurationManager >> configRetrievedAnnounced: aBoolean [

	configRetrievedAnnounced := aBoolean
	
]

{ #category : #accessing }
ARDConfigurationManager >> configuration [
	"Returns the multiline configuration string received from the drone (via TCP port 5559)"
	^ configuration
]

{ #category : #accessing }
ARDConfigurationManager >> configuration: aString [
	"Sets the multiline configuration string received from the drone (via TCP port 5559)"
	configuration := aString
]

{ #category : #initialization }
ARDConfigurationManager >> initialize [
	super initialize.
	suspendProcess := true.
	terminateProcess := false.
	configuration := ''.
	timeLastUpdate := 0.
	retrieverProcess := 
	[ [ suspendProcess ifTrue: [ Processor activeProcess suspend ].
		self retrieveConfigurationFile. 
		(Delay forMilliseconds: self retrieveTimeout) wait.
		] repeat 
	] newProcess.
	retrieverProcess name: 'Config retriever Process'
]

{ #category : #api }
ARDConfigurationManager >> resume [
	"Resumes all processes associated with this instance."
	suspendProcess := false.
	adapterTCP connect.
	retrieverProcess resume.
]

{ #category : #'retrieving config file' }
ARDConfigurationManager >> retrieveConfigurationFile [
	| received |
	adapterTCP isConnected ifFalse: [ adapterTCP connect ].
		
	self arDrone commandManager configControlMode: ARDConstant controlMode_ACK_CONTROL_MODE.
	self arDrone commandManager configControlMode: ARDConstant controlMode_CFG_GET_CONTROL_MODE.
		
	[received := adapterTCP receive asString.
		(self useFile: received toGetvalueForParameter: 'rescue:rescue') 
		ifNotNil: [ 
			configuration := received. 
			self configRetrievedAnnounced ifFalse: [ 
				self arDrone announcer announce: DroneConfigurationFileReceivedForTheFirstTime. 
				self configRetrievedAnnounced: true 
				].
			self arDrone announcer announce: DroneConfigurationFileReceived. 
			timeLastUpdate := Time now.
			].
		] 
		on: Exception 
		do: [ :e | Transcript show: 'exception receiving config file: ' , (e asString);cr ]
	
]

{ #category : #accessing }
ARDConfigurationManager >> retrieveTimeout [
	^ 500
]

{ #category : #api }
ARDConfigurationManager >> stopRetrieving [
	"Finishes the process that receives navdata."
	retrieverProcess terminate. 
	adapterTCP closeAndDestroy 
]

{ #category : #api }
ARDConfigurationManager >> suspend [
	"Suspends all processes associated with this instance."
	suspendProcess := true.
]

{ #category : #api }
ARDConfigurationManager >> terminate [
	self stopRetrieving 
]

{ #category : #accessing }
ARDConfigurationManager >> timeLastUpdate [
	^ timeLastUpdate 
]

{ #category : #accessing }
ARDConfigurationManager >> useFile: aConfigString toGetvalueForParameter: aString [
	| regex match val |
	aConfigString ifNil: [^ nil].
	regex := (aString, ' = \w+') copyReplaceAll:':' with:'\:'.
	match := [((regex asRegex  matchesIn: aConfigString) at: 1) asString] on:SubscriptOutOfBounds do: [ ^ nil ]. 	
	val := (match substrings: '= ') at: 2.
	val = 'TRUE' ifTrue: [ ^ true ].
	val = 'FALSE' ifTrue: [ ^ false ].
	^ val.
]

{ #category : #accessing }
ARDConfigurationManager >> valueForParameter: aString [
	| regex match val |
	"usar useFile...."
	configuration ifNil: [^ nil].
	regex := (aString, ' = \w+') copyReplaceAll:':' with:'\:'.
	match := [((regex asRegex  matchesIn: configuration) at: 1) asString] on:SubscriptOutOfBounds do: [ ^ nil ]. 	
	val := (match substrings: '= ') at: 2.
	val = 'TRUE' ifTrue: [ ^ true ].
	val = 'FALSE' ifTrue: [ ^ false ].
	^ val.
]
