"
I raise when the drone doesn't send back the right authentication response
"
Class {
	#name : #DroneAuthenticationFailed,
	#superclass : #Exception,
	#category : #ARDrone
}

{ #category : #accessing }
DroneAuthenticationFailed >> defaultAction [

	UnhandledError signalForException: self
]

{ #category : #accessing }
DroneAuthenticationFailed >> description [

	^ 'DroneAuthenticationFailed Exception: Is there any other device connected to the drone?'
]

{ #category : #accessing }
DroneAuthenticationFailed >> messageText [

	^ 'Is there any other device connected to the drone?'
]
