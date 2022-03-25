"
I represent a 3D position of the drone
"
Class {
	#name : #ARDPoint,
	#superclass : #Point,
	#instVars : [
		'z'
	],
	#category : #ARDrone
}

{ #category : #accessing }
ARDPoint >> x: xNumber y: yNumber z: zNumber [

	x := xNumber.
	y := yNumber.
	z := zNumber.

]
