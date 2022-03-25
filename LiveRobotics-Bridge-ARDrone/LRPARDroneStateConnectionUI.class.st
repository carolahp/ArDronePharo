Class {
	#name : #LRPARDroneStateConnectionUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'connectionState',
		'icon',
		'label'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneStateConnectionUI class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed 
			newRow: [ :row |
				row add: #icon width: self iconDiameter.
			 	row add: #label
		] height: self toolbarHeight; 
		yourself.
	
]

{ #category : #specs }
LRPARDroneStateConnectionUI class >> iconDiameter [
	^ 20
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> arDroneInstance [
	^ arDroneInstance
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.
	
]

{ #category : #update }
LRPARDroneStateConnectionUI >> connectionState [
	^ connectionState
]

{ #category : #update }
LRPARDroneStateConnectionUI >> connectionState: anInt [
	| color message |
	
	connectionState := anInt.
	connectionState = ARDConstant connection_CONNECTED
		ifTrue: [ color := Color green. 
					 message := 'Connected'. ].
					
	connectionState = ARDConstant connection_DISCONNECTED
		ifTrue: [ color := Color red.
					  message := 'Disconnected'. ].
				
	connectionState = ARDConstant connection_CONNECTING
		ifTrue: [ color := Color yellow.  
						message := 'Connecting...'.].
	

	self updateIconImage: color.

	icon changed: #getImage.
	label label: message.
	
	
	
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> errorMessage: aString [
	
	label label: 'Disconected - Connection Lost: ', aString.
	
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> icon [
	^ icon
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> icon: anObject [
	icon := anObject 
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> initializeWidgets [
	| blackdot |
	label := self newLabel.
	icon := self newImage.	
	
	blackdot := ColorForm dotOfSize: self class iconDiameter.
	icon image: (ColorForm mappingWhiteToTransparentFrom: blackdot).	
	
	self connectionState: ARDConstant connection_DISCONNECTED.
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> label [
	^ label
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> label: anObject [
	label := anObject
]

{ #category : #accessing }
LRPARDroneStateConnectionUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone.
	
]

{ #category : #update }
LRPARDroneStateConnectionUI >> updateIconImage: aColor [
	| r |
	r := self class iconDiameter/2.	
	icon image replaceColorAt: r@r with: aColor.
	
	
]
