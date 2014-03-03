private
registerNewClass: aClass 
	"Private - Register new class and answer its classInfo."

	| info pos stream unlocked |
	unlocked := false.
	info := ODBSerializer classDescriptionFor: aClass.
	idTable waitForAddingLock.
	
	[pos := infoFile at: aClass name
				ifAbsent: 
					[stream := infoFile stream.
					pos := stream setToEnd.
					info classID: (idTable add: pos).
					stream putLong: 0.	"info of previous class version"
					info saveOnStream: stream.	"class definition"
					stream putLong: info classID.	"class ID"
					infoFile
						at: info name put: pos;
						flush.
					unlocked := idTable unlockAdding.
					self addClassInfo: info.
					^info].
	idTable unlockAdding] 
			ifCurtailed: [unlocked ifFalse: [idTable unlockAdding]].
	pos := self loadInfoChainFrom: pos.
	(info := self find: aClass) isNil ifFalse: [^info].
	^self registerNewClassVersion: aClass from: pos