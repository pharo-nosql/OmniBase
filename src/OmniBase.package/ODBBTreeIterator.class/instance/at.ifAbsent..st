public
at: aString ifAbsent: aBlock 
	| key association |
	key := ByteArray new: keyLength.
	key replaceFrom: 1 to: (aString size min: keyLength) with: aString startingAt: 1.
	association := self goToAndGetCurrentAt: key.
	self clearSearchCache.
	association isNil ifTrue: [^aBlock value].
	^association value odbLongAt: 1