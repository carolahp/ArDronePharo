"
I represent an AT command for sending to the ar drone.

API messages:
	-  ARDCommand class >> withPrefix: sequence: arguments:
			-> returns an instance of this class
Example:	
	For creating an ARDCommand that represents the next AT command:
		AT*CONFIG=605,""video:video_on_usb"",""TRUE""
	you must instanciate me in the following way:
		newCommand := withPrefix:'AT*CONFIG' sequence: 605 arguments: { 'video:video_on_usb', 'TRUE' }
		
On my class side, under the ""preset messages"" protocol, I contain a set of preset commands, ready to be send to the drone.
Besides, under the ""enumerating - associations"" protocol, I contain a set of messages for intuitively refering to values that can be send inside AT commands.

		
Instance variables:
	- prefix <String>
	- sequenceNumber <Integer>
	- argumentCollection <Collection<String or Integer>>





"
Class {
	#name : #ARDCommand,
	#superclass : #Object,
	#instVars : [
		'prefix',
		'sequenceNumber',
		'argumentCollection'
	],
	#category : #ARDrone
}

{ #category : #'preset messages' }
ARDCommand class >> ackControlModeMessage [
	
	^ 'AT*CTRL=0', Character cr asString
]

{ #category : #'preset messages' }
ARDCommand class >> authMessage [
	
	^ 'PARROT AUTH'
]

{ #category : #'preset messages' }
ARDCommand class >> authResponse [
	
	^ 'PARROT AUTH AR.DRONE OK'
]

{ #category : #'preset messages' }
ARDCommand class >> navdataKeepAliveMessage [
	
	^ Character home asString, Character null asString .
]

{ #category : #'instance creation' }
ARDCommand class >> withPrefix: aPrefix arguments: anArgumentCollection [
	"Returns an instance of ARDCommand, the arguments types must be:
	- aPrefix <String>
	- aSequenceNumber <Integer>
	- anArgumentCollection <aCollection> (must contain Numeric or String)"
	^ (self new)
		prefix: aPrefix;
		sequenceNumber: 0;
		arguments: anArgumentCollection 
]

{ #category : #accessing }
ARDCommand >> arguments [

	^ argumentCollection
]

{ #category : #accessing }
ARDCommand >> arguments: aCollection [

	argumentCollection := aCollection
]

{ #category : #converting }
ARDCommand >> asByteArray [

	^ self asString asByteArray
]

{ #category : #converting }
ARDCommand >> asString [
	"Returns a String representation of this command, ready to be understood by the drone's firmware"
	| cmdString dq cr |
	dq := (prefix = 'AT*CONFIG_IDS') 
		ifTrue: ['']
		ifFalse: [$" asString].
	cr := Character cr asString .
	cmdString := prefix, '=', sequenceNumber asString .
	(1 to: (argumentCollection size)) do: [ :i |
		| arg |
		arg := (argumentCollection at: i) .
		"Transcript show: arg asString; cr ."
		(arg class = ByteString) 
			ifTrue: [ cmdString := cmdString, ',', dq, arg asString, dq ] 
			ifFalse: [ cmdString := cmdString, ',', arg asString ] .
	
	] .
	cmdString := cmdString, cr .
	^ cmdString
	
]

{ #category : #converting }
ARDCommand >> isAStabilizeCommand [
	^ [((self prefix = 'AT*PCMD') and: (self arguments size = 5)) 
		and: (((self arguments copyFrom:2 to: 5) select: [ :each | each = 0 ]) size = 4 ).]
		on: Exception do: [^ false. ]
	
]

{ #category : #accessing }
ARDCommand >> prefix [

	^ prefix
]

{ #category : #accessing }
ARDCommand >> prefix: aString [

	prefix := aString
]

{ #category : #accessing }
ARDCommand >> sequenceNumber [

	^ sequenceNumber 
]

{ #category : #accessing }
ARDCommand >> sequenceNumber: anInt [

	sequenceNumber := anInt
]
