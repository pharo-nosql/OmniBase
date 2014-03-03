public
serialize: anObject
	onStream: aStream
	referenceManager: aReferenceManager
	classManager: aClassManager

	| startPos endPos |
	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aClassManager.
	mainObject := anObject.
	classes := ODBIdentityDictionary new: 31.
	objects := ODBIdentityDictionary new: 63.
	counter := 0.
	classesCounter := 0.
	classCollection := OrderedCollection new: 30.
	startPos := stream position.
	stream putLong: 0.

	mainObject odbSerialize: self.

	endPos := stream position.
	stream
		position: startPos;
		putLong: counter;
		position: endPos.