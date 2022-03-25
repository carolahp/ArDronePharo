"
I raise when the drone doesn't respond to a configuration command. The drone must be restarted in order to success in configuring.
"
Class {
	#name : #DroneConfigurationAttemptFailed,
	#superclass : #Exception,
	#category : #ARDrone
}

{ #category : #'as yet unclassified' }
DroneConfigurationAttemptFailed >> defaultAction [

	UnhandledError signalForException: self
]

{ #category : #'as yet unclassified' }
DroneConfigurationAttemptFailed >> description [

	^ 'DroneConfigurationAttemptFailed: Restart the drone'
]
