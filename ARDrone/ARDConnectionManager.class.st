"
I'm the ARDConnectionManager. I authenticate to the drone and announce when the connection is lost. 

IMPORTANT: It's the user's responsibility to terminate each instance of this class using the message ARDConnectionManager>>terminate (this message is called from ARDrone terminateSession). If the instance is not terminated, one process will keep running in background

"
Class {
	#name : #ARDConnectionManager,
	#superclass : #Object,
	#instVars : [
		'arDrone',
		'mutex',
		'timer',
		'watchdogProcess',
		'connectionState',
		'reconnectTimeout',
		'gcTimer'
	],
	#category : #ARDrone
}

{ #category : #'instance creation' }
ARDConnectionManager class >> withARDrone: anARDrone [
	"Returns an ARDConnectionManager instance for managing the connection with drone. 
	The argument type must be:
	- anARDrone <ARDrone>"
	^ (self new arDrone: anARDrone).

]

{ #category : #private }
ARDConnectionManager >> announce: anAnnouncement [
	arDrone announcer announce: anAnnouncement
]

{ #category : #accessing }
ARDConnectionManager >> arDrone [
	"Returns the ARDrone instance for which this Connection Manager was created"
	^ arDrone
]

{ #category : #accessing }
ARDConnectionManager >> arDrone: anARDrone [
	"Sets the ARDrone instance for which this Connection Manager was created"
	arDrone := anARDrone.
	self subscribe.
]

{ #category : #api }
ARDConnectionManager >> authenticate [

	"Authenticates to the drone's firmware, sending a message to the drone and waiting for a specific response."
	| authAdapter  received success |
	self halt: 'Deprecated'.
	
	authAdapter := ARDAdapterUDP withARDrone: arDrone
										port: ARDConstant port_AUTH
										isMulticast: false
										delayInterval: 30.
	authAdapter send: ARDCommand authMessage.
	[ received := authAdapter 
						receiveWithin: arDrone authTimeout 
						onTimeout: [ DroneConnectionTimeout signal ].
	] on: Exception
	  do: [ :ex | 
				arDrone excecuteHandlerFor: ex.
				^ false 
	  ].
	success := (received asString copyFrom: 1 to: 23) = ARDCommand authResponse.
	success ifFalse: [ DroneAuthenticationFailed signal ].
	
	^ success
				
]

{ #category : #private }
ARDConnectionManager >> collectGarbage [
	gcTimer := 
	self doIfItsTime: [ Smalltalk garbageCollect. ]
	mustBeDoneEvery: 10000 
	lastTimeDone: gcTimer.
]

{ #category : #accessing }
ARDConnectionManager >> connectionState [
	
	^ connectionState
]

{ #category : #private }
ARDConnectionManager >> doIfItsTime: aBlock mustBeDoneEvery: anInterval lastTimeDone: lastTime [
	"Excecutes aBlock every anInterval seconds, according to the timer lastTime, if the block is excecuted it returns the updated value of lastTime, if not, it returns the original lastTime value."
	| newLastTime |
	newLastTime := lastTime.
	((Time now asMilliSeconds - lastTime) >= anInterval) 
			ifTrue: [ 
				aBlock value . 
				newLastTime := Time now asMilliSeconds ].
	^ newLastTime
]

{ #category : #api }
ARDConnectionManager >> initialize [
	super initialize.
	connectionState := ARDConstant connection_DISCONNECTED.

]

{ #category : #private }
ARDConnectionManager >> initializeWatchdogProcess [

	gcTimer := Time now asMilliSeconds.
	watchdogProcess ifNotNil: [ watchdogProcess terminate ]. 
	watchdogProcess := 
	[[ self sendWatchDogCommand .
		timer := timer - self watchdogDelay.
		( timer <= 0 ) 
		ifTrue: [ 
			self reconnect 
			ifFalse: [ self announce: DroneConnectionStop ]].
		"self collectGarbage ." 
		
		(Delay forSeconds: self watchdogDelay) wait .
	] repeat ] fork.
	
	watchdogProcess name: 'Watchdog Process'.
	^ watchdogProcess 
]

{ #category : #private }
ARDConnectionManager >> reconnect [
	| announced connected startTime |
	"announced variable used for announcing and signal exception only once."
	announced := false.
	connected := false.
	startTime := Time now asSeconds.
	[ connected ] 
			whileFalse: [
				( announced )
				ifFalse: [  arDrone announcer announce: DroneConnecting.
								announced := true.
								arDrone signalAndHandle: DroneConnectionInterrupted ].
				Transcript show: 'connecting'; cr.
				[ connected := self startReceiving ] 
				on: PrimitiveFailed  
	  			do: [ :ex |(Delay forSeconds: 0.5) wait. ].
				"if timeout happens"
				(Time now asSeconds - startTime > (self reconnectTimeout))
					ifTrue: [ arDrone signalAndHandle: DroneConnectionTimeout.
								 self announce: DroneConnectionStop.
								 ^ false. ]
			].
	"if the excecution reaches here, the connection has been established"
	timer  := self watchdogTimeout.
	Transcript show: 'SIGNAL connection start';cr.
	self announce: DroneConnectionStart.
	^ true
]

{ #category : #accessing }
ARDConnectionManager >> reconnectTimeout [
	"Maximum time (in seconds) for trying to reconnect before signaling the DroneConnectionTimeout exception"
	^ reconnectTimeout ifNil: [ reconnectTimeout := 5 ]
]

{ #category : #accessing }
ARDConnectionManager >> reconnectTimeout: anInt [
	"Maximum time (in seconds) for trying to reconnect before signaling the DroneConnectionTimeout exception"
	reconnectTimeout := anInt
]

{ #category : #sending }
ARDConnectionManager >> sendKeepAliveMessage [
	"Send tickle bytes to navdataSocket"
	(arDrone navdataAdapter) send: ARDCommand navdataKeepAliveMessage. 	 

	
	
]

{ #category : #private }
ARDConnectionManager >> sendWatchDogCommand [
	"Transcript show: 'Watchdog reset!';cr."
	(arDrone commandManager) enqueue: (ARDCommand withPrefix: 'AT*COMWDG' arguments: { } )
]

{ #category : #api }
ARDConnectionManager >> startReceiving [
	| dg |
	Transcript show: 'start receiving';cr.
	"send first message to start receiving navdata"
	self sendKeepAliveMessage. 
	dg := arDrone navdataManager receive .
	dg ifNil: [ ^ false ].
	(dg containsData) ifFalse: [^ false ].
	arDrone resetSequenceNumber .
	
	^ true.
]

{ #category : #private }
ARDConnectionManager >> startWatchdog [

	timer := 0. "this is 0 so the process tries to connect inmediatly"
	self initializeWatchdogProcess
]

{ #category : #private }
ARDConnectionManager >> stopWatchdog [
	
	watchdogProcess ifNotNil: [ watchdogProcess terminate. ]
	
	
]

{ #category : #private }
ARDConnectionManager >> subscribe [
	"subscribes to the necessary announcements."
	| firstConnection |
	firstConnection := true.
	
	arDrone announcer 
		subscribe: DroneNavdataPacketReceived 
		do: [ timer := self watchdogTimeout. ].
		
	arDrone announcer 
		subscribe: DroneConnectionStart 
		do: [ connectionState := ARDConstant connection_CONNECTED. 
				arDrone commandManager resume.
				arDrone navdataManager resume.
				arDrone configurationManager configRetrievedAnnounced: false.
				arDrone configurationManager resume.
				firstConnection 
				ifTrue: [ 
					Transcript show: 'Sending config';cr.
					firstConnection := false.
					(arDrone commandManager configNavdataDefaultOptions) 
					ifFalse: [ 
						self announce: DroneConnectionStop.
						DroneConfigurationAttemptFailed signal. ]]].
	
	arDrone announcer 
		subscribe: DroneConnectionStop  
		do: [ connectionState := ARDConstant connection_DISCONNECTED. 
				"Transcript show: 'suspend processes';cr."
				self terminate.
				arDrone commandManager suspend.
				arDrone navdataManager suspend. 
				arDrone configurationManager suspend.].
	
	arDrone announcer 
		subscribe: DroneConnecting   
		do: [ connectionState := ARDConstant connection_CONNECTING.
				Transcript show: 'suspend processes while reconnecting';cr.
				arDrone commandManager suspend.
				arDrone navdataManager suspend. 
				arDrone configurationManager suspend.].
	
]

{ #category : #api }
ARDConnectionManager >> terminate [
	self stopWatchdog.
	self unsubscribe. 

]

{ #category : #accessing }
ARDConnectionManager >> timer [ 
	^ timer
]

{ #category : #accessing }
ARDConnectionManager >> timer: anInt [ 
	timer := anInt
]

{ #category : #private }
ARDConnectionManager >> unsubscribe [
	"subscribes to the NavdataPacketReceived announcement."
	arDrone announcer unsubscribe: DroneNavdataPacketReceived.
	arDrone announcer unsubscribe: DroneConnectionStart. 
	arDrone announcer unsubscribe: DroneConnectionStop.
	arDrone announcer unsubscribe: DroneConnecting.	
]

{ #category : #accessing }
ARDConnectionManager >> watchdogDelay [
	"Delay for every watchdog cycle"
	^ 0.1
]

{ #category : #accessing }
ARDConnectionManager >> watchdogTimeout [
	"Maximum time (in seconds) passed between receiving two navdata packets, before considering the connection lost and try to reconnect"
	^ 2
]
