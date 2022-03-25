Class {
	#name : #LRPARDroneStateBatteryUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'label',
		'message',
		'percentage'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneStateBatteryUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed 
			newRow: [ :row |
				row add: #label.
			 	row add: #message.
		] height: self toolbarHeight; 
		yourself.

]

{ #category : #specs }
LRPARDroneStateBatteryUI class >> lowBatteryThreshold [
	^ 30
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> arDroneInstance [
	^ arDroneInstance
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.
	
]

{ #category : #initialization }
LRPARDroneStateBatteryUI >> initializeWidgets [
	label := self newLabel.
	message := self newLabel.
	
	label label: 'Battery'.
	message label: ''.
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> label [
	^ label
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> label: anObject [
	label := anObject
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> message [
	^ message
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> message: anObject [
	message := anObject
]

{ #category : #update }
LRPARDroneStateBatteryUI >> percentage [
	^ percentage
]

{ #category : #update }
LRPARDroneStateBatteryUI >> percentage: anInt isLow: aBoolean [
	anInt isNil 
	ifTrue: [ 
		label label: 'Battery level'.
		message label: '' ]
	ifFalse: [
		label label: anInt asString, '%  Battery level'.
		aBoolean 
		ifTrue: [ message label: 'Low Battery' . message color: Color red]
		ifFalse: [ message label: '' .  ]
	].
	label changed: #getText.
	message changed: #getText.
]

{ #category : #accessing }
LRPARDroneStateBatteryUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone 
]
