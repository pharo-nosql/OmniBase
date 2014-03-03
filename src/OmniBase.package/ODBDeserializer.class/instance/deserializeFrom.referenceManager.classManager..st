public
deserializeFrom: aStream referenceManager: aReferenceManager classManager: aClassManager 
	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aClassManager.
	classArray := self class classArray.
	objects := Array new: stream getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self nextObject