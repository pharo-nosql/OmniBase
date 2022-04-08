Extension { #name : #Class }

{ #category : #'*omnibase' }
Class >> odbBasicSerialize: serializer [

	serializer stream putByte: 26; putString: name asString
]

{ #category : #'*omnibase' }
Class class >> odbDeserialize: deserializer [

	^Smalltalk at: deserializer stream getString asSymbol ifAbsent: nil
]

{ #category : #'*omnibase' }
Class >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]

{ #category : #'*omnibase' }
Class >> odbTransientInstanceVariables [
		"This method tells OmniBase which instance variables should not be stored into the database."

	^OrderedCollection new
]
