"
I raise when no response is received from the drone after attempting to reconnect n times (default n = 10 times, it can be modified by the user)
"
Class {
	#name : #DroneConnectionTimeout,
	#superclass : #Exception,
	#category : #ARDrone
}

{ #category : #accessing }
DroneConnectionTimeout >> defaultAction [

	UnhandledError signalForException: self
]

{ #category : #accessing }
DroneConnectionTimeout >> description [

	^ 'DroneConnectionTimeout Exception: Are you connected to the drone network?'
]

{ #category : #accessing }
DroneConnectionTimeout >> messageText [

	^ 'Are you connected to the drone network?'
]
