*omnibase
odbDeserialize: deserializer 
	| result |
	deserializer register: (result := self new).
	^result
		receiver: deserializer nextObject;
		selector: deserializer nextObject;
		arguments: deserializer nextObject;
		yourself