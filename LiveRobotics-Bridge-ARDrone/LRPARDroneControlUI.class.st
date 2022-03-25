Class {
	#name : #LRPARDroneControlUI,
	#superclass : #ComposableModel,
	#instVars : [
		'arDroneInstance',
		'takeoffButton',
		'landButton',
		'videoButton',
		'changeVideoButton',
		'label',
		'keyboardListener',
		'morphKB',
		'videoProcess'
	],
	#category : #'LiveRobotics-Bridge-ARDrone'
}

{ #category : #specs }
LRPARDroneControlUI class >> defaultSpec [
	<spec: #default>
	| row1 row2 row3 |
	
	row1 := SpecLayout composed
		newRow: [ :row |
			row add: #takeoffButton.
			row add: #landButton.
		] height: self toolbarHeight;
		yourself.
	
	row2 := SpecLayout composed 
		newRow: [ :row |
			row add: #label.
			row add: #keyboardListener.
		] height: self toolbarHeight; 
		yourself.
	
	row3 := SpecLayout composed
		newRow: [ :row |
			row add: #videoButton.
			row add: #changeVideoButton.
		] height: self toolbarHeight;
		yourself.
	
	^ SpecLayout composed
		newColumn: [ :col |
			col add: row1.
			col add: row2.
			col add: row3.
		];yourself. 
]

{ #category : #accessing }
LRPARDroneControlUI >> arDroneInstance [
	^arDroneInstance
]

{ #category : #accessing }
LRPARDroneControlUI >> arDroneInstance: anARDrone [
	arDroneInstance := anARDrone.
	morphKB arDrone: anARDrone.


]

{ #category : #accessing }
LRPARDroneControlUI >> changeVideoButton [

	 ^ changeVideoButton
]

{ #category : #accessing }
LRPARDroneControlUI >> changeVideoButton: anObject [

	 changeVideoButton := anObject 
]

{ #category : #accessing }
LRPARDroneControlUI >> enabled: aBoolean [
	takeoffButton enabled: aBoolean.
	landButton enabled: aBoolean.
	keyboardListener enabled: aBoolean.
	videoButton ifNotNil: [ videoButton enabled: aBoolean] .
	changeVideoButton ifNotNil: [ changeVideoButton enabled: aBoolean] .	
	
]

{ #category : #initialization }
LRPARDroneControlUI >> initializeWidgets [
	takeoffButton := self newButton.
	landButton := self newButton.
	videoButton := self newButton.
	changeVideoButton := self newButton.
	label := self newLabel.
	morphKB := ARDUIKeyboard withARDrone: self arDroneInstance.
	keyboardListener :=  morphKB asSpecAdapter.
	
	takeoffButton label: 'Take off'.
	landButton label: 'Land'.
	videoButton label: 'Show video'.
	changeVideoButton label: 'Change camera'.
	label label: 'Keyboard control:'.
	
	takeoffButton 
		action: [ arDroneInstance takeOff. keyboardListener takeKeyboardFocus].
	landButton 
		action: [ arDroneInstance land . keyboardListener takeKeyboardFocus].
	videoButton
		action: [  self runVideoProcess . keyboardListener takeKeyboardFocus].
	changeVideoButton 
		action: [ arDroneInstance changeVideoChannel .keyboardListener takeKeyboardFocus].
	self enabled: false.
]

{ #category : #accessing }
LRPARDroneControlUI >> keyboardListener [

	 ^ keyboardListener 
]

{ #category : #accessing }
LRPARDroneControlUI >> keyboardListener: anObject [

	 keyboardListener := anObject 
]

{ #category : #accessing }
LRPARDroneControlUI >> label [
	 ^ label
]

{ #category : #accessing }
LRPARDroneControlUI >> label: anObject [
	 label := anObject
]

{ #category : #accessing }
LRPARDroneControlUI >> landButton [
	^ landButton
]

{ #category : #accessing }
LRPARDroneControlUI >> landButton: anObject [
	landButton := anObject
]

{ #category : #'video processing' }
LRPARDroneControlUI >> resumeVideoProcess [
	videoProcess ifNotNil: [ videoProcess exitStatus ifNil: [ self runVideoProcess ] ]
]

{ #category : #'video processing' }
LRPARDroneControlUI >> runVideoProcess [
	self terminateVideoProcess.
	videoProcess := OSProcess command: ('exec ', self videoProcessPath asString)
]

{ #category : #accessing }
LRPARDroneControlUI >> setARDroneInstance: anARDrone [
	self arDroneInstance: anARDrone.
]

{ #category : #'video processing' }
LRPARDroneControlUI >> suspendVideoProcess [
	videoProcess ifNotNil: [ 
		videoProcess sigterm .
	] 
]

{ #category : #accessing }
LRPARDroneControlUI >> takeoffButton [
	 ^ takeoffButton
]

{ #category : #accessing }
LRPARDroneControlUI >> takeoffButton: anObject [
	takeoffButton := anObject.
]

{ #category : #'video processing' }
LRPARDroneControlUI >> terminateVideoProcess [
	videoProcess ifNotNil: [ 
		videoProcess terminate.  
	] 
]

{ #category : #accessing }
LRPARDroneControlUI >> videoButton [
	^ videoButton
]

{ #category : #accessing }
LRPARDroneControlUI >> videoButton: anObject [
	videoButton := anObject
]

{ #category : #accessing }
LRPARDroneControlUI >> videoProcess [

	^ videoProcess
]

{ #category : #accessing }
LRPARDroneControlUI >> videoProcess: anObject [

	videoProcess := anObject 
]

{ #category : #accessing }
LRPARDroneControlUI >> videoProcessPath [

	^ '~/Documents/ARDrone_SDK_2_0_1/ARDrone_SDK_2_0_1/Examples/Linux/Build/Release/linux_video_demo'.
]
