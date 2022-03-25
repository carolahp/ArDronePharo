Class {
	#name : #LRPARDroneUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'state',
		'control',
		'config',
		'navdata',
		'emergencyButton',
		'resetButton',
		'connectButton',
		'navdataButton'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneUI class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
	  newColumn: [ :mainColumn|
			mainColumn add: #connectButton height: self toolbarHeight.
			mainColumn add: #control height: self toolbarHeight * 3.5.
			mainColumn add: #config height: self toolbarHeight * 2.
			mainColumn add: #navdataButton height: self toolbarHeight. 
			mainColumn add: #state height: self toolbarHeight.
	];
	yourself. 
]

{ #category : #specs }
LRPARDroneUI class >> title [
	^ 'AR.Drone'
]

{ #category : #accessing }
LRPARDroneUI >> arDroneInstance [
	^ arDroneInstance 
	
]

{ #category : #accessing }
LRPARDroneUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone 
	
]

{ #category : #accessing }
LRPARDroneUI >> config [ 
	^ config
]

{ #category : #accessing }
LRPARDroneUI >> config: anObject [
	config := anObject
]

{ #category : #accessing }
LRPARDroneUI >> connectButton [
	^ connectButton
	
]

{ #category : #accessing }
LRPARDroneUI >> connectButton: anObject [
	connectButton := anObject
	
]

{ #category : #accessing }
LRPARDroneUI >> connected [
	^ self state connection connectionState = ARDConstant connection_CONNECTED  
	
]

{ #category : #accessing }
LRPARDroneUI >> control [
	^ control
	
]

{ #category : #accessing }
LRPARDroneUI >> control: anObject [
	control := anObject
	
]

{ #category : #accessing }
LRPARDroneUI >> defaultWindowModelClass [

	^ TickingWindowModel 
]

{ #category : #api }
LRPARDroneUI >> extent [
	^400@300
]

{ #category : #initialization }
LRPARDroneUI >> initialize [
	super initialize.

	"on close unsubscribe"
	self whenWindowChanged: [  
		self window whenClosedDo: [ 
			self unsubscribe.
			self control terminateVideoProcess.
			self navdata window ifNotNil: [ self navdata window close ] 
		].
		
	].

	self whenBuiltDo: [
		self connectButton enabled: true.
		self navdataButton enabled: false.
		self control enabled: false.
		self config enabled: false. ]
]

{ #category : #initialization }
LRPARDroneUI >> initializeExceptionHandlers [
	
	self arDroneInstance addHandlerFor: DroneConnectionTimeout 
		do: [ :ex | Transcript show: 'Timeout';cr].
	
	self arDroneInstance addHandlerFor: DroneConnectionInterrupted 
		do: [ :ex | Transcript show: 'Connection interrupted';cr. ].
	

]

{ #category : #initialization }
LRPARDroneUI >> initializeWidgets [
	
	state := LRPARDroneStateUI new.
	control := LRPARDroneControlUI new.
	config := LRPARDroneConfigUI new.
	navdata := LRPARDroneNavdataUI new.
	
	connectButton := self newButton.
	navdataButton := self newButton.
	
	connectButton label: 'Connect'.
	navdataButton label: 'Show navdata'.
	
	connectButton action: [ arDroneInstance startSession ].
	navdataButton action: [ navdata openWithSpec ]


]

{ #category : #accessing }
LRPARDroneUI >> navdata [
	^ navdata
	
]

{ #category : #accessing }
LRPARDroneUI >> navdata: anObject [
	navdata := anObject
	
]

{ #category : #accessing }
LRPARDroneUI >> navdataButton [
	^ navdataButton
	
]

{ #category : #accessing }
LRPARDroneUI >> navdataButton: anObject [
	navdataButton := anObject
	
]

{ #category : #initialization }
LRPARDroneUI >> setARDroneInstance: anARDrone [

	self arDroneInstance: anARDrone.
	state setARDroneInstance: anARDrone.
	control setARDroneInstance: anARDrone.
	config setARDroneInstance: anARDrone.
	
	self initializeExceptionHandlers.
	self subscribe.
	
]

{ #category : #accessing }
LRPARDroneUI >> state [
	^ state
	
]

{ #category : #accessing }
LRPARDroneUI >> state: anObject [
	state := anObject
	
]

{ #category : #update }
LRPARDroneUI >> step [
	self connected 
		ifTrue: [ 
			self state battery 
				percentage: arDroneInstance batteryLevel 
				isLow: arDroneInstance lowBattery.
				"Transcript show: ('Roundel detected: ' , arDroneInstance tagsNumberDetected asString, ' oriented: ', arDroneInstance roundelTagIsOrientedAndCentered asString), ' HoverOnTop: ' , ((arDroneInstance configFlyingMode asInteger = (ARDConstant flyingMode_HOVER_ON_TOP_OF_ORIENTED_ROUNDEL )) asString) ;cr."
				"self state tags message: arDroneInstance tagsInformationAsString." ]
		ifFalse: [ config enabled: false. ]. 


]

{ #category : #private }
LRPARDroneUI >> subscribe [
	self arDroneInstance announcer 
		subscribe: DroneConnectionStart
		do: [ self state connection connectionState: ARDConstant connection_CONNECTED .
				self connectButton enabled: false. 
				self navdataButton enabled: true.
				self control enabled: true.
				self config enabled: false.
				self control suspendVideoProcess.
			].
		
	self arDroneInstance announcer  
		subscribe: DroneConnectionStop
		do: [ self state connection connectionState: ARDConstant connection_DISCONNECTED. 
				self connectButton enabled: true.
				self navdataButton enabled: false.
				self control enabled: false.
				self config enabled: false.].	
	
	self arDroneInstance announcer  
		subscribe: DroneConnecting 
		do: [ self state connection connectionState: ARDConstant connection_CONNECTING. 
				self connectButton enabled: false.
				self navdataButton enabled: false.
				self control enabled: false.
				self config enabled: false.
				self control suspendVideoProcess. ].	
	
	self arDroneInstance announcer  
		subscribe: DroneConfigurationFileReceivedForTheFirstTime 
		do: [ self config enabled: true. 
				self config updateStateFromDroneConfiguration. ].
	self arDroneInstance announcer  
		subscribe: DroneNavdataPacketReceived  
		do: [ self navdata textBox text: (arDroneInstance lastNavdataPacketReceived asStringVerbose: false) ]
	
]

{ #category : #private }
LRPARDroneUI >> unsubscribe [
	
	self arDroneInstance announcer unsubscribe: DroneConnectionStart.
	self arDroneInstance announcer unsubscribe: DroneConnectionStop.
	self arDroneInstance announcer unsubscribe: DroneConnecting.
	self arDroneInstance announcer unsubscribe: DroneConfigurationFileReceivedForTheFirstTime.	
	
]
