Class {
	#name : #LRPARDroneConfigUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'labelExternalSettings',
		'buttonIndoorHull',
		'buttonOutdoor',
		'labelFlyingMode',
		'buttonFlyFree',
		'buttonFlyOnTopOfRoundel',
		'enabled'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneConfigUI class >> defaultSpec [
	<spec: #default>
	| row1 row2 |
	
	row1 := SpecLayout composed
		newRow: [ :row |
			row add: #labelExternalSettings.
			row add: #buttonIndoorHull.
			row add: #buttonOutdoor. ] 
		height: self toolbarHeight;
		yourself.
	
	row2 := SpecLayout composed 
		newRow: [ :row |
			row add: #labelFlyingMode.
			row add: #buttonFlyFree.
			row add: #buttonFlyOnTopOfRoundel.
		] height: self toolbarHeight; 
		yourself.
	
	^ SpecLayout composed 
		newColumn: [ :col |
			col add: row1.
			col add: row2.
		]; yourself.
]

{ #category : #accessing }
LRPARDroneConfigUI >> arDroneInstance [
	^arDroneInstance
]

{ #category : #accessing }
LRPARDroneConfigUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.


]

{ #category : #accessing }
LRPARDroneConfigUI >> buttonFlyFree [

	^ buttonFlyFree 
]

{ #category : #accessing }
LRPARDroneConfigUI >> buttonFlyOnTopOfRoundel [

	^ buttonFlyOnTopOfRoundel 
]

{ #category : #accessing }
LRPARDroneConfigUI >> buttonIndoorHull [

	^ buttonIndoorHull 
]

{ #category : #accessing }
LRPARDroneConfigUI >> buttonOutdoor [

	^ buttonOutdoor 
]

{ #category : #accessing }
LRPARDroneConfigUI >> enabled [
	^ enabled
	
]

{ #category : #accessing }
LRPARDroneConfigUI >> enabled: aBoolean [
	enabled := aBoolean.
	buttonIndoorHull enabled: aBoolean.
	buttonOutdoor enabled: aBoolean.
	buttonFlyFree enabled: aBoolean.
	buttonFlyOnTopOfRoundel enabled: aBoolean
	
]

{ #category : #accessing }
LRPARDroneConfigUI >> initializePresenter [
	
	buttonIndoorHull whenActivatedDo: [ arDroneInstance configFlightWithoutShell: false ].
	buttonIndoorHull whenDeactivatedDo: [ arDroneInstance configFlightWithoutShell: true ].
	buttonOutdoor whenActivatedDo: [ arDroneInstance configOutdoor: true ].
	buttonOutdoor whenDeactivatedDo: [ arDroneInstance configOutdoor: false ].
	
	buttonFlyFree whenActivatedDo: [ arDroneInstance configFlyingModeFreeFlight ].
	buttonFlyOnTopOfRoundel whenActivatedDo: [ arDroneInstance configFlyingModeHoverOnTopOfRoundel ].
	
]

{ #category : #initialization }
LRPARDroneConfigUI >> initializeWidgets [ 

	buttonIndoorHull 			:= self newCheckBox.
	buttonOutdoor 				:= self newCheckBox.
	labelExternalSettings 	:= self newLabel.
	buttonFlyFree 				:= self newRadioButton.
	buttonFlyOnTopOfRoundel 	:= self newRadioButton.  
	labelFlyingMode 			:= self newLabel.
	
	buttonIndoorHull 			label: 'Indoor Hull'.
	buttonOutdoor 				label: 'Outdoor Flight'.
	labelExternalSettings 	label: 'External settings'.
	buttonFlyFree 				label: 'Free'.
	buttonFlyOnTopOfRoundel 	label: 'On top of Roundel'.
	labelFlyingMode 			label: 'Flying Mode:'.
	
	self setFocus.
	self setGroup.
	
		
]

{ #category : #accessing }
LRPARDroneConfigUI >> labelExternalSettings [

	^ labelExternalSettings
]

{ #category : #accessing }
LRPARDroneConfigUI >> labelFlyingMode [

	^ labelFlyingMode
]

{ #category : #accessing }
LRPARDroneConfigUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone.
]

{ #category : #initialization }
LRPARDroneConfigUI >> setFocus [
	
	self focusOrder
		add: buttonIndoorHull;
		add: buttonOutdoor;
		add: buttonFlyFree;
		add: buttonFlyOnTopOfRoundel.
]

{ #category : #initialization }
LRPARDroneConfigUI >> setGroup [

	RadioButtonGroup new 
		addRadioButton: buttonFlyFree;
		addRadioButton: buttonFlyOnTopOfRoundel.
	
]

{ #category : #update }
LRPARDroneConfigUI >> updateStateFromDroneConfiguration [
	self buttonIndoorHull state: arDroneInstance configFlightWithoutShell not.
	self buttonOutdoor state: arDroneInstance configOutdoor.
	self buttonFlyFree state: (arDroneInstance configFlyingMode asInteger = ARDConstant flyingMode_FREE_FLIGHT asInteger).
	self buttonFlyOnTopOfRoundel state: (arDroneInstance configFlyingMode asInteger = ARDConstant flyingMode_HOVER_ON_TOP_OF_ORIENTED_ROUNDEL asInteger).
]
