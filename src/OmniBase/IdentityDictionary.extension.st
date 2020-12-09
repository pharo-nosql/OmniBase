Extension { #name : #IdentityDictionary }

{ #category : #'*omnibase' }
IdentityDictionary >> odbBasicSerialize: serializer [

	self class == IdentityDictionary ifFalse: [ ^super odbBasicSerialize: serializer ].
	serializer
		stream putByte: 38;
		putPositiveInteger: self size.
	self keysAndValuesDo: [:key :value |
		key odbSerialize: serializer.
		value odbSerialize: serializer.
	].
]
