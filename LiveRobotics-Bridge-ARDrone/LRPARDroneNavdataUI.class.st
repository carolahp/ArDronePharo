Class {
	#name : #LRPARDroneNavdataUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'textBox'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneNavdataUI class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
	  newColumn: [ :mainColumn|
			mainColumn add: #textBox.
	];
	yourself. 
]

{ #category : #specs }
LRPARDroneNavdataUI class >> title [
	^ 'Navdata'
]

{ #category : #accessing }
LRPARDroneNavdataUI >> arDroneInstance [
	^ arDroneInstance
]

{ #category : #accessing }
LRPARDroneNavdataUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone 
	
]

{ #category : #api }
LRPARDroneNavdataUI >> extent [
	^300@600
]

{ #category : #initialization }
LRPARDroneNavdataUI >> initializeWidgets [
	textBox := self newText
]

{ #category : #accessing }
LRPARDroneNavdataUI >> textBox [
	^ textBox
	
]

{ #category : #accessing }
LRPARDroneNavdataUI >> textBox: aTextModel [
	textBox := aTextModel 
	
]
