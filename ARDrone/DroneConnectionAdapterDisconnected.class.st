"
I raise when the drone wireless adapter is not connected to any network
"
Class {
	#name : #DroneConnectionAdapterDisconnected,
	#superclass : #Exception,
	#category : #ARDrone
}

{ #category : #accessing }
DroneConnectionAdapterDisconnected >> defaultAction [

	UnhandledError signalForException: self
]
