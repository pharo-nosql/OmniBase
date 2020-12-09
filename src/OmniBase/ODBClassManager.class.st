Class {
	#name : #ODBClassManager,
	#superclass : #Object,
	#instVars : [
		'classes',
		'idTable',
		'infoFile',
		'mutex',
		'names'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBClassManager class >> new [

    ^super new initialize
]

{ #category : #private }
ODBClassManager >> addClassDescription: aClassDescription withId: classId [ 
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
]

{ #category : #'private/unclassified' }
ODBClassManager >> addClassInfo: aClassInfo [
        "Private - Add class info to names dictionary."

    | id |
    id := aClassInfo classID.
    id > classes size
        ifTrue: [
            id - classes size timesRepeat: [ classes add: nil].
            classes at: id put: aClassInfo.
            self addToDict: aClassInfo]
        ifFalse: [
            (classes at: id) isNil ifTrue: [
                classes at: id put: aClassInfo.
                self addToDict: aClassInfo]]
]

{ #category : #private }
ODBClassManager >> addToDict: aClassInfo [ 
	"Private - Add class info to names dictionary."

	| coll |
	(coll := names at: aClassInfo realClass) isNil 
		ifTrue: [^names at: aClassInfo realClass put: aClassInfo].
	coll class == OrderedCollection ifTrue: [^coll add: aClassInfo].
	names at: aClassInfo realClass put: (OrderedCollection with: coll with: aClassInfo)
]

{ #category : #public }
ODBClassManager >> classDescriptionAt: anInteger [ 
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
]

{ #category : #'public/create/open/close' }
ODBClassManager >> close [

    idTable isNil ifFalse: [idTable close].
    infoFile isNil ifFalse: [infoFile close]
]

{ #category : #public }
ODBClassManager >> createOn: anOmniBase [ 
	mutex := Semaphore forMutualExclusion.
	
	[infoFile := ODBClassInfoFile createOn: anOmniBase dirName , self infoFileName.
	idTable := ODBIDTable createOn: anOmniBase dirName , self idFileName] 
			ifCurtailed: [self close]
]

{ #category : #private }
ODBClassManager >> find: aClass [ 
	"Private - Answer class description for aClass or <nil> if none.
	Uses #createdFor: to check if class description corresponds to aClass."

	| coll |
	(coll := names at: aClass) isNil ifTrue: [^nil].
	coll class == OrderedCollection ifFalse: [^(coll createdFor: aClass) ifTrue: [coll]].
	coll reverseDo: [:classInfo | (classInfo createdFor: aClass) ifTrue: [^classInfo]].
	^nil
]

{ #category : #private }
ODBClassManager >> idFileName [
	^ODBFileStream pathSeparatorString , 'omnibase.odt'
]

{ #category : #private }
ODBClassManager >> infoFileName [
	^ODBFileStream pathSeparatorString , 'omnibase.odl'
]

{ #category : #private }
ODBClassManager >> initialize [
	classes := OrderedCollection new.
	names := ODBIdentityDictionary new
]

{ #category : #private }
ODBClassManager >> lastClassId [
	^idTable getLastID
]

{ #category : #'private/unclassified' }
ODBClassManager >> loadInfoChainFrom: anInteger [
        "Private - Load class info chain from pos. Answer end of list."

    | info pos lastPos stream |
    pos := anInteger.
    stream := infoFile stream.
    [pos == 0] whileFalse: [
        stream position: pos.
        lastPos := pos.
        pos := stream getLong.
        info := ODBSerializer classDescriptionFrom: stream.
        info classID: stream getLong.
        self addClassInfo: info].
    ^lastPos
]

{ #category : #public }
ODBClassManager >> openOn: anOmniBase [ 
	"Open receiver. Signal an error if failed."

	mutex := Semaphore forMutualExclusion.
	
	[idTable := ODBIDTable openOn: anOmniBase dirName , self idFileName.
	infoFile := ODBClassInfoFile openOn: anOmniBase dirName , self infoFileName] 
			ifCurtailed: [self close]
]

{ #category : #public }
ODBClassManager >> register: aClass [ 
	"Answer an instance of ODBClassDescription for aClass.
	ODBClassDescription holds meta information about objects in the database."

	| info pos |
	mutex critical: 
			[(info := self find: aClass) isNil ifFalse: [^info].
			pos := infoFile at: aClass name ifAbsent: [^self registerNewClass: aClass].
			pos := self loadInfoChainFrom: pos.
			(info := self find: aClass) isNil ifFalse: [^info].
			^self registerNewClassVersion: aClass from: pos]
]

{ #category : #private }
ODBClassManager >> registerNewClass: aClass [ 
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
]

{ #category : #private }
ODBClassManager >> registerNewClassVersion: aClass from: anInteger [ 
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
]
