private
addClassDescription: aClassDescription withId: classId 
	"Private - Add aClassDescription under a given ID."

	| pos stream unlocked previousVersionPos lastPos classDesc |
	aClassDescription isNil 
		ifTrue: 
			[[idTable getLastID < classId] whileTrue: [idTable add: 0].
			^self].
	unlocked := false.
	stream := infoFile stream.
	idTable waitForAddingLock.
	
	[pos := infoFile at: aClassDescription name
				ifAbsent: 
					[pos := stream setToEnd.
					[idTable getLastID < classId] whileTrue: [idTable add: 0].
					idTable at: classId put: pos.
					aClassDescription classID: classId.
					stream putLong: 0.	"info of previous class version"
					aClassDescription saveOnStream: stream.	"class definition"
					stream putLong: aClassDescription classID.	"class ID"
					infoFile
						at: aClassDescription name put: pos;
						flush.
					unlocked := idTable unlockAdding.
					^self].
	
	[lastPos := pos.
	stream position: pos.
	previousVersionPos := stream getLong.
	classDesc := ODBSerializer classDescriptionFrom: stream.
	classDesc classID: stream getLong.
	previousVersionPos = 0] 
			whileFalse: [pos := previousVersionPos].
	pos := stream setToEnd.
	stream putLong: 0.
	aClassDescription saveOnStream: stream.
	stream
		putLong: classId;
		position: lastPos;
		putLong: pos;
		flush.
	[idTable getLastID < classId] whileTrue: [idTable add: 0].
	idTable at: classId put: pos.
	idTable unlockAdding] 
			ifCurtailed: [unlocked ifFalse: [idTable unlockAdding]]