*omnibase
asBtreeKeyOfSize: keySize

	keySize < 3 ifTrue: [OmniBase signalError: 'Key size has to be at least 3 bytes to accomodate a date'].
	^self julianDayNumber asBtreeKeyOfSize: keySize