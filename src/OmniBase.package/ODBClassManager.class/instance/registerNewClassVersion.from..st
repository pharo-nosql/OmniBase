private
registerNewClassVersion: aClass from: anInteger 
	"Private - Register new class version and answer its classInfo."

	| info pos lastPos stream unlocked |
	unlocked := false.
	idTable waitForAddingLock.
	
	[stream := infoFile stream.
	pos := anInteger.
	[true] whileTrue: 
			[lastPos := pos.
			stream position: pos.
			pos := stream getLong.
			pos == 0 
				ifTrue: 
					[info := ODBSerializer classDescriptionFor: aClass.
					pos := stream setToEnd.
					info classID: (idTable add: pos).
					stream putLong: 0.
					info saveOnStream: stream.
					stream
						putLong: info classID;
						position: lastPos;
						putLong: pos;
						flush.
					unlocked := idTable unlockAdding.
					self addClassInfo: info.
					^info].
			info := ODBSerializer classDescriptionFrom: stream.
			info classID: stream getLong.
			self addClassInfo: info.
			(info := self find: aClass) isNil 
				ifFalse: 
					[unlocked := idTable unlockAdding.
					^info]]] 
			ifCurtailed: [unlocked ifFalse: [idTable unlockAdding]]