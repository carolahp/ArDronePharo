"
I'm a bridge to ARDrone. I enable communicating with the AR.Drone from LRP
"
Class {
	#name : #LRPARDroneBridge,
	#superclass : #LRPAbstractBridge,
	#classVars : [
		'arDroneInstance'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #accessing }
LRPARDroneBridge >> arDroneInstance [
	^arDroneInstance

	
]

{ #category : #accessing }
LRPARDroneBridge >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone

	
]

{ #category : #cleanup }
LRPARDroneBridge >> cleanUp [
	(self arDroneInstance isNotNil)
		ifTrue: [self arDroneInstance terminateSession].
	super cleanUp.
	
]

{ #category : #generating }
LRPARDroneBridge >> generateConfigurationMethods [
	
	self 
		addMethod: ('changeVideoChannel')
		source: ('^__lrpBridge arDroneInstance changeVideoChannel').
	self 
		addMethod: ('modeHoverOnTopOfRoundel')
		source: ('^__lrpBridge arDroneInstance configFlyingModeHoverOnTopOfRoundel').
	self 
		addMethod: ('modeFreeFlight')
		source: ('^__lrpBridge arDroneInstance configFlyingModeFreeFlight').
]

{ #category : #generating }
LRPARDroneBridge >> generateFlightMethods [
	
	self 
		addMethod: ('animateFlight: aFlightAnimationNumber duration: aDuration')
		source: ('^__lrpBridge arDroneInstance animateFlight: aFlightAnimationNumber duration: aDuration').
]

{ #category : #generating }
LRPARDroneBridge >> generateLEDMethods [
	
	self 
		addMethod: ('animateLEDs: aLEDAnimationNumber frequency: aFrequency duration: aDuration')
		source: ('^__lrpBridge arDroneInstance animateLEDs: aLEDAnimationNumber frequency: aFrequency duration: aDuration').
	self 
		addMethod: ('ledsFireForever')
		source: ('^__lrpBridge arDroneInstance animateLEDs: ', 
					ARDConstant ledAnimation_FIRE asString,
					' frequency: 5 duration: 60').
	self 
		addMethod: ('ledsBlinkRedForever')
		source: ('^__lrpBridge arDroneInstance animateLEDs: ', 
					ARDConstant ledAnimation_BLINK_RED asString,
					' frequency: 8 duration: 60').
	
	self 
		addMethod: ('ledsBlinkGreenForever')
		source: ('^__lrpBridge arDroneInstance animateLEDs: ', 
					ARDConstant ledAnimation_BLINK_GREEN asString,
					' frequency: 8 duration: 60').
	self 
		addMethod: ('ledsStandard')
		source: ('^__lrpBridge arDroneInstance animateLEDs: ', 
					ARDConstant ledAnimation_GREEN asString,
					' frequency: 8 duration: 60').
]

{ #category : #generating }
LRPARDroneBridge >> generateMethods [
	
	self generateNavdataMethods.
	self generateMovementMethods.
	self generateStateMethods.  
	self generateLEDMethods.
	self generateFlightMethods. 
	self generateConfigurationMethods.
	self generateTagDetectionMethods. 
]

{ #category : #generating }
LRPARDroneBridge >> generateMovementMethods [
	
	self 
		addMethod: ('takeOff')
		source: ('^__lrpBridge arDroneInstance takeOff').
	self 
		addMethod: ('land')
		source: ('^__lrpBridge arDroneInstance land').
	self 
		addMethod: ('roll: aFloat')
		source: ('^__lrpBridge arDroneInstance roll: aFloat').
	self 
		addMethod: ('pitch: aFloat')
		source: ('^__lrpBridge arDroneInstance pitch: aFloat').
	self 
		addMethod: ('yaw: aFloat')
		source: ('^__lrpBridge arDroneInstance yaw: aFloat').
	self 
		addMethod: ('elevate: aFloat')
		source: ('^__lrpBridge arDroneInstance elevate: aFloat').
	self 
		addMethod: ('stabilize')
		source: ('^__lrpBridge arDroneInstance stabilize').
	
]

{ #category : #generating }
LRPARDroneBridge >> generateNavdataMethods [
	
	self 
		addMethod: ('receiverProcessCallback: aBlock')
		source: ('^__lrpBridge arDroneInstance receiverProcessCallback: aBlock').
]

{ #category : #generating }
LRPARDroneBridge >> generateStateMethods [
	
	self 
		addMethod: ('isFlying')
		source: ('^__lrpBridge arDroneInstance isFlying').
	self 
		addMethod: ('roll')
		source: ('^__lrpBridge arDroneInstance roll').
	self 
		addMethod: ('altitude')
		source: ('^__lrpBridge arDroneInstance altitude').
	
]

{ #category : #generating }
LRPARDroneBridge >> generateTagDetectionMethods [
	
	
	self 
		addMethod: ('tagsNumberDetected')
		source: ('^__lrpBridge arDroneInstance tagsNumberDetected').
	self 
		addMethod: ('tagsType')
		source: ('^__lrpBridge arDroneInstance tagsType').
	self 
		addMethod: ('tagsDistance')
		source: ('^__lrpBridge arDroneInstance tagsDistance').
	self 
		addMethod: ('tagsHeight')
		source: ('^__lrpBridge arDroneInstance tagsHeight').
	self 
		addMethod: ('tagsWidth')
		source: ('^__lrpBridge arDroneInstance tagsWidth').
	self 
		addMethod: ('tagsYc')
		source: ('^__lrpBridge arDroneInstance tagsYc').
	self 
		addMethod: ('tagsXc')
		source: ('^__lrpBridge arDroneInstance tagsXc').
	self 
		addMethod: ('tagsOrientationAngle')
		source: ('^__lrpBridge arDroneInstance tagsOrientationAngle').
	self 
		addMethod: ('tagsRotation')
		source: ('^__lrpBridge arDroneInstance tagsRotation').
	self 
		addMethod: ('tagsCameraSource')
		source: ('^__lrpBridge arDroneInstance tagsCameraSource').
	self  
		addMethod: ('roundelTagIsOrientedAndCentered')
		source: ('^__lrpBridge arDroneInstance roundelTagIsOrientedAndCentered').
	self  
		addMethod: ('roundelTagDetected')
		source: ('^__lrpBridge arDroneInstance roundelTagDetected').	
	self  
		addMethod: ('shellTagDetected')
		source: ('^__lrpBridge arDroneInstance shellTagDetected').	
	
	self  
		addMethod: ('shellTagIsCentered')
		source: ('^__lrpBridge arDroneInstance shellTagIsCentered').	
	
	self addMethod: ('shellTagMoveAndFollow')
		source: ('^__lrpBridge arDroneInstance shellTagMoveAndFollow').	
	
]

{ #category : #ui }
LRPARDroneBridge >> openUIFor: anInterpreter [
	self setupARDrone. 
	self generateMethods.
	^ LRPARDroneUI new setARDroneInstance: (self arDroneInstance); openWithSpec.
]

{ #category : #setup }
LRPARDroneBridge >> setupARDrone [

	self arDroneInstance: ARDrone newUniqueInstance

	
]
