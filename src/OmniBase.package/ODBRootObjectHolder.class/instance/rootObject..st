public
rootObject: anObject 
	"Set object represented by the receiver."

	changed := true.
	transaction makePersistent: anObject.
	dataBaseObject := anObject