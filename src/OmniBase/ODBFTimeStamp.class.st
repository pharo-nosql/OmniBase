Class {
	#name : #ODBFTimeStamp,
	#superclass : #DateAndTime,
	#category : #'OmniBase-Types'
}

{ #category : #'as yet unclassified' }
ODBFTimeStamp >> asBtreeKeyOfSize: keySize [ 
	keySize < 8 
		ifTrue: 
			[OmniBase signalError: 'Key size has to be at least 8 bytes to accomodate a timestamp'].
	^self asSeconds asBtreeKeyOfSize: keySize
]
