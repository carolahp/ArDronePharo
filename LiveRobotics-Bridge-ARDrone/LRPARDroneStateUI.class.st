Class {
	#name : #LRPARDroneStateUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'battery',
		'connection',
		'tags'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneStateUI class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed 
			newRow: [ :row |
				row add: #battery.
			 	row add: #connection.
		] height: self toolbarHeight;
	yourself.
]

{ #category : #accessing }
LRPARDroneStateUI >> arDroneInstance [
	^ arDroneInstance
]

{ #category : #accessing }
LRPARDroneStateUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.
	
]

{ #category : #accessing }
LRPARDroneStateUI >> battery [
	^ battery
]

{ #category : #accessing }
LRPARDroneStateUI >> battery: anObject [
	battery := anObject
]

{ #category : #accessing }
LRPARDroneStateUI >> connection [
	^ connection
]

{ #category : #accessing }
LRPARDroneStateUI >> connection: anObject [
	connection := anObject
]

{ #category : #accessing }
LRPARDroneStateUI >> initializeWidgets [
	battery := LRPARDroneStateBatteryUI new.
	connection := LRPARDroneStateConnectionUI new.
	"tags := LRPARDroneStateTagsUI new."
]

{ #category : #accessing }
LRPARDroneStateUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone.
	self connection setARDroneInstance: anARDrone.
	self battery setARDroneInstance: anARDrone.
	"self tags setARDroneInstance: anARDrone." 
	
]

{ #category : #accessing }
LRPARDroneStateUI >> tags [
	^ tags
]

{ #category : #accessing }
LRPARDroneStateUI >> tags: anObject [
	tags := anObject
]
