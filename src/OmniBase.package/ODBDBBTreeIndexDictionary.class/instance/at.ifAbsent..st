public
at: aKey ifAbsent: aBlock 
	| association |
	^(association := iterator goToAndGetCurrentAt: ((ByteArray new: iterator keyLength) 
						replaceFrom: 1
						to: (aKey size min: iterator keyLength)
						with: aKey
						startingAt: 1)) 
		isNil ifTrue: [aBlock value] ifFalse: [ODBValueHolder createOn: association value]