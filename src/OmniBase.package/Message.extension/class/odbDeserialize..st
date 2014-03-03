*omnibase
odbDeserialize: deserializer 
	| result |
	deserializer register: (result := self new).
	^result
		setSelector: deserializer nextObject arguments: deserializer nextObject;
		yourself