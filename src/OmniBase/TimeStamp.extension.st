Extension { #name : #TimeStamp }

{ #category : #'*omnibase' }
TimeStamp >> asBtreeKeyOfSize: keySize [ 
	keySize < 8 
		ifTrue: 
			[OmniBase signalError: 'Key size has to be at least 8 bytes to accomodate a timestamp'].
	^self asSeconds asBtreeKeyOfSize: keySize
]
