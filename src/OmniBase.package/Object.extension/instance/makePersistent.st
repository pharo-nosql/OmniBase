*omnibase
makePersistent
	"Makes the object persistent in the current process's transaction.
	Note: because is not specifiying where, this instance is going to 
	be persisted in the default container."

	"Note: using a dynamic variable could allow to still use the #makePersistent message
	while deciding somewhere else in which container this should be stored.
	It would look like:
	ARCurrentContainer value isNil
		ifTrue:[OmniBase currentTransaction makePersistent: self]
		ifFalse:[OmniBase currentTransaction makePersistent: self in: ARCurrentContainer value]"
	
	OmniBase currentTransaction makePersistent: self
		