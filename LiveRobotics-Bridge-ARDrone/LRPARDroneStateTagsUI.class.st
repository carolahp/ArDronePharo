Class {
	#name : #LRPARDroneStateTagsUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'message',
		'orientation'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneStateTagsUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed 
			newRow: [ :row |
			 	row add: #message.
		] height: self toolbarHeight * 8; 
		yourself.

]

{ #category : #accessing }
LRPARDroneStateTagsUI >> arDroneInstance [
	^ arDroneInstance
]

{ #category : #accessing }
LRPARDroneStateTagsUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.
	
]

{ #category : #initialization }
LRPARDroneStateTagsUI >> initializeWidgets [
	message := self newText.
	message text: 'No Tags detected'.
	message disable.
]

{ #category : #accessing }
LRPARDroneStateTagsUI >> message [
	^ message
]

{ #category : #accessing }
LRPARDroneStateTagsUI >> message: aString [
	message text: aString.
	message changed: #getText.
]

{ #category : #accessing }
LRPARDroneStateTagsUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone 
]
