Extension { #name : #Integer }

{ #category : #'*ARDrone' }
Integer class >> from32BitArrayWithOnesAt: aCollection [
	"Returns a 32 bit unsigned int from an array that contains the position of ones in the bit array that will generate the integer. Bit positions start at 0 and finish at 31"
	| unsignedInteger |
	unsignedInteger := 0.
	(1 to: 32) do: [ :i |
		(aCollection contains: [:a | a = (32 - i) ])
		ifTrue: [ unsignedInteger := unsignedInteger + (2 raisedTo: (32 - i)) ]  ].
	^ unsignedInteger
]
