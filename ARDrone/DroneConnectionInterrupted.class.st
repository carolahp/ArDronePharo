"
I raise when has passed 0.5 seconds since the last navdata arrived and no other navdata packet has been received
"
Class {
	#name : #DroneConnectionInterrupted,
	#superclass : #Exception,
	#category : #ARDrone
}

{ #category : #accessing }
DroneConnectionInterrupted >> defaultAction [

	UnhandledError signalForException: self
]
