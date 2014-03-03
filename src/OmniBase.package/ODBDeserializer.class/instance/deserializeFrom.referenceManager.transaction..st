public
deserializeFrom: aStream
	referenceManager: aReferenceManager
	transaction: aTransaction

	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aTransaction environment classManager.
	transaction := aTransaction.
	classArray := self class classArray.
	objects := Array new: stream getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self odbNextObject