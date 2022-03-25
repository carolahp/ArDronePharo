"
I represent the drone's motion state on a certain moment, according to its velocity and tilt.
I'm designed to be an instance variable within the ARDrone's class, so I can save the drone's desired motion state in every moment, and I can be read by the motionCommandsSenderProcess (run by ARDCommandManager) to determine the tilts an velocities of every motion command that it sends to the real drone.
 
API messages:
	- ARDMotionState >> new
			-> returns an instance of the class.
	
	- ARDMotionState >> angularSpeed:
			-> sets the angular speed
			
	- ARDMotionState >> frontBackTilt:
			-> sets the front back tilt
	
	- ARDMotionState >> leftRightTilt:
			-> sets the left right tilt
	
	- ARDMotionState >> verticalSpeed:
			-> sets the vertical speed

Instance variables:

-leftRightTilt (roll or phi angle) 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 	
			- (-) for left, (+) for right.

- frontBackTilt (pitch or theta angle) 
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 
			- (-) for front (drone lowers its nose), (+) for back (drone raises its nose)

- VerticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending.

- AngularSpeed (yaw)
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left.
"
Class {
	#name : #ARDMotionState,
	#superclass : #Object,
	#instVars : [
		'leftRightTilt',
		'frontBackTilt',
		'verticalSpeed',
		'angularSpeed'
	],
	#category : #ARDrone
}

{ #category : #accessing }
ARDMotionState >> angularSpeed [
	" Represents the drone's angularSpeed 
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left."
	^ angularSpeed
]

{ #category : #accessing }
ARDMotionState >> angularSpeed: aFloat [
	" Represents the drone's angularSpeed 
			- float in range [-1,1] 
			- is a percentage of the maximum angular speed 
			- (+) for spinning right, (-) for spinning left."
	angularSpeed := aFloat asFloat
]

{ #category : #accessing }
ARDMotionState >> containsOnlyZeros [
	^ (self angularSpeed = 0) &
	  (self verticalSpeed = 0) &
	  (self frontBackTilt = 0) &
	  (self leftRightTilt = 0)
]

{ #category : #accessing }
ARDMotionState >> frontBackTilt [
	" Represents the drone's pitch or theta angle
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 
			- (-) for front (drone lowers its nose), (+) for back (drone raise its nose)"
	^ frontBackTilt 
]

{ #category : #accessing }
ARDMotionState >> frontBackTilt: aFloat [
	" Represents the drone's pitch or theta angle
			- float in range [-1,1] 
			- represents a percentage of the max pitch inclination set for the drone 
			- (-) for front (drone lowers its nose), (+) for back (drone raise its nose)"
	frontBackTilt := aFloat asFloat
]

{ #category : #initialization }
ARDMotionState >> initialize [

	super initialize.
	leftRightTilt := 0.0.
	frontBackTilt := 0.0.
	verticalSpeed := 0.0.
	angularSpeed := 0.0
]

{ #category : #accessing }
ARDMotionState >> leftRightTilt [
	" Represents the drone's roll or phi angle 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 									 			
			- (-) for left, (+) for right."
	^ leftRightTilt 
]

{ #category : #accessing }
ARDMotionState >> leftRightTilt: aFloat [
	" Represents the drone's roll or phi angle 	
			- float in range [-1,1] 
			- represents a percentage of the max roll inclination set for the drone 									 			
			- (-) for left, (+) for right."
	leftRightTilt := aFloat asFloat 
]

{ #category : #accessing }
ARDMotionState >> verticalSpeed [
	" Represents the drone's verticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending."
	^ verticalSpeed
]

{ #category : #accessing }
ARDMotionState >> verticalSpeed: aFloat [
	" Represents the drone's verticalSpeed (gaz) 
			- float in range [-1,1] 
			- is a percentage of the maximum vertical speed 
			- (+) for elevating, (-) for descending."
	verticalSpeed := aFloat asFloat
]
