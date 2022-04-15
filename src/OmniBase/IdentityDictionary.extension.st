Extension { #name : #IdentityDictionary }

{ #category : #'*omnibase' }
IdentityDictionary >> odbBasicSerialize: serializer [

	serializer stream nextPutIdentityDictionary: self
]
