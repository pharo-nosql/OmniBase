public
classDescriptionAt: anInteger 
	"Answers class at class id anInteger."

	| pos classInfo stream |
	mutex critical: 
			[classes size < anInteger 
				ifFalse: [(classInfo := classes at: anInteger) isNil ifFalse: [^classInfo]].
			(pos := idTable at: anInteger) isNil 
				ifTrue: [OmniBase signalError: 'Unknown class ID in serialized persistent object'].
			stream := infoFile stream.
			stream position: pos + 4.
			classInfo := ODBSerializer classDescriptionFrom: stream.
			classInfo classID: anInteger.
			self addClassInfo: classInfo].
	^classInfo