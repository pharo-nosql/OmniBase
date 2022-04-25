Extension { #name : #Class }

{ #category : #'*omnibase' }
Class >> odbBasicSerialize: serializer [

	serializer stream nextPutClass: self
]

{ #category : #'*omnibase' }
Class class >> odbDeserialize: deserializer [

	^ deserializer stream nextClass
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
