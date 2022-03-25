Extension { #name : #Float }

{ #category : #'*ARDrone' }
Float >> asARDEquivalentInteger [
	"Returns the binary equivalent signed int for this float as 32bit float"
	| byteArray bitArray  signedInteger |

byteArray := self asIEEE32BitWord printStringHex.
byteArray = '0' ifTrue: [ ^ 0 ].
bitArray := ''.
(1 to: 8) do: [ :i | 
	| thisByte |
	thisByte := (byteArray at: i) asString. 
	thisByte = '0' ifTrue: [ bitArray := bitArray , '0000' ].
	thisByte = '1' ifTrue: [ bitArray := bitArray , '0001' ].
	thisByte = '2' ifTrue: [ bitArray := bitArray , '0010' ].
	thisByte = '3' ifTrue: [ bitArray := bitArray , '0011' ].
	thisByte = '4' ifTrue: [ bitArray := bitArray , '0100' ].
	thisByte = '5' ifTrue: [ bitArray := bitArray , '0101' ].
	thisByte = '6' ifTrue: [ bitArray := bitArray , '0110' ].
	thisByte = '7' ifTrue: [ bitArray := bitArray , '0111' ].
	thisByte = '8' ifTrue: [ bitArray := bitArray , '1000' ].
	thisByte = '9' ifTrue: [ bitArray := bitArray , '1001' ].
	thisByte = 'A' ifTrue: [ bitArray := bitArray , '1010' ].
	thisByte = 'B' ifTrue: [ bitArray := bitArray , '1011' ].
	thisByte = 'C' ifTrue: [ bitArray := bitArray , '1100' ].
	thisByte = 'D' ifTrue: [ bitArray := bitArray , '1101' ].
	thisByte = 'E' ifTrue: [ bitArray := bitArray , '1110' ].
	thisByte = 'F' ifTrue: [ bitArray := bitArray , '1111' ].
	].

signedInteger := -1 * (2 raisedTo: 31) * ((bitArray at: 1) asString asInteger).
(2 to: 32) do: [ :i |
	signedInteger := signedInteger + ((2 raisedTo: (32 - i)) * ((bitArray at: i) asString asInteger)).
	].
	^ signedInteger
]
