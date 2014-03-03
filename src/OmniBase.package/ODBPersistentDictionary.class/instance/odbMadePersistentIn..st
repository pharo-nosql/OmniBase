private
odbMadePersistentIn: anOmniBaseTransaction 
	"This method is sent when the object is made persistent."

	transaction notNil 
		ifTrue: [self error: 'Object is already persistent in another transaction'].
	transaction := anOmniBaseTransaction.
	self do: [:each | each isImmediate ifFalse: [transaction makePersistent: each]]