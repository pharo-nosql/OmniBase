public
getPositiveInteger
	"Answer the next Integer encoded in the receiver. 
	Works for one collection only."

	| answer |
	(answer := current at: (position := position + 1)) > 127 ifFalse: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)