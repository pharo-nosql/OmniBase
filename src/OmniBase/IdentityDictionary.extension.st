Extension { #name : #IdentityDictionary }

{ #category : #'*omnibase' }
IdentityDictionary >> odbBasicSerialize: serializer [
	self class == IdentityDictionary ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutIdentityDictionary: self
]
