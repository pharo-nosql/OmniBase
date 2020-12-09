Extension { #name : #Month }

{ #category : #'*omnibase' }
Month >> asBtreeKeyOfSize: keySize [

	^ self asDate asBtreeKeyOfSize: keySize
]
