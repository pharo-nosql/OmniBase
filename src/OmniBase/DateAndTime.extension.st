Extension { #name : #DateAndTime }

{ #category : #'*omnibase' }
DateAndTime >> asBtreeKeyOfSize: keySize [ 

	keySize < 8 ifTrue: [
		OmniBase signalError: 'Key size has to be at least 8 bytes to accomodate a DateAndTime'].

	^self asSeconds asBtreeKeyOfSize: keySize
]
