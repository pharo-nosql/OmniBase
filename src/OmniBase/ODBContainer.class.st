Class {
	#name : #ODBContainer,
	#superclass : #Object,
	#instVars : [
		'activeDataFile',
		'byteStorageQueue',
		'dataFileA',
		'dataFileB',
		'dbFiles',
		'dbFilesMutex',
		'id',
		'indexFile',
		'name',
		'objectManager',
		'path',
		'queueSize'
	],
	#category : #'OmniBase-Storage'
}

{ #category : #public }
ODBContainer >> addByteStorageRequest: anODBByteStorageRequest [ 
	byteStorageQueue add: anODBByteStorageRequest.
	queueSize := queueSize + anODBByteStorageRequest bytes size.
	queueSize > 65536 ifTrue: [self flushBytes]
]

{ #category : #accessing }
ODBContainer >> at: index [

	| bytes |
	(bytes := indexFile at: index) ifNil: [ ^ nil ].
	^ (ODBObjectHolder createOn: bytes)
		  setContainer: self
		  objectID: (ODBObjectID containerID: id index: index)
]

{ #category : #accessing }
ODBContainer >> bytesAllocated [

	| size1 size2 |
	size1 := 0.
	size2 := 0.
	dataFileA ifNotNil: [ size1 := dataFileA size ].
	dataFileB ifNotNil: [ size2 := dataFileB size ].
	^ size1 + size2
]

{ #category : #public }
ODBContainer >> close [

	dbFiles do: [ :each | each ifNotNil: [ each close ] ].
	indexFile ifNotNil: [ indexFile close ].
	dataFileA ifNotNil: [ dataFileA close ].
	dataFileB ifNotNil: [ dataFileB close ]
]

{ #category : #public }
ODBContainer >> closeObjectFile: anInteger [ 
	"Remove database object file number anInteger from 
        dictionary of opened files and close it."

	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file
				close]
]

{ #category : #public }
ODBContainer >> convertToLocalObjectSpaceNumber: objectSpaceNumber [ 
	^indexFile swappedObjectSpaces ifTrue: [1 - objectSpaceNumber] ifFalse: [objectSpaceNumber]
]

{ #category : #public }
ODBContainer >> createNewObjectSpace [

	"Create new object space for garbage collection."

	dataFileA
		ifNil: [ dataFileA := ODBObjectStorage createOn: self dataFileNameA ]
		ifNotNil: [ 
			dataFileB ifNil: [ 
				dataFileB := ODBObjectStorage createOn: self dataFileNameB ] ]
]

{ #category : #public }
ODBContainer >> createOn: aString [ 
	"Create new container on containerPath."

	path := aString.
	
	[indexFile := ODBObjectIndexFile createOn: self indexFileName.
	objectManager defaultObjectSpace == 0 
		ifTrue: 
			[dataFileA := ODBObjectStorage createOn: self dataFileNameA.
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB := ODBObjectStorage createOn: self dataFileNameB.
			activeDataFile := dataFileB]] 
			ifCurtailed: [self close]
]

{ #category : #private }
ODBContainer >> dataFileNameA [
	^ path / 'objects.a'
]

{ #category : #private }
ODBContainer >> dataFileNameB [
	^ path / 'objects.b'
]

{ #category : #public }
ODBContainer >> dataFileSize [
	^activeDataFile stream size
]

{ #category : #private }
ODBContainer >> fileNameFromIndex: anInteger [ 
	"Private - Answer object file name from index."

	^ path / anInteger printString , 'btr'
]

{ #category : #public }
ODBContainer >> flushBytes [
	"Store byte array queue to dataFile and update object holders in queue."

	| pos bufPos stream buf size bytes objectPosition |
	queueSize == 0 ifTrue: [^self].
	self lockDataFile.
	stream := activeDataFile stream.
	pos := stream 
		setToEnd;
		position.
	buf := ByteArray new: queueSize.
	bufPos := 0.
	byteStorageQueue do: 
			[:each | 
			bytes := each bytes.
			size := bytes size.
			buf 
				replaceFrom: bufPos + 1
				to: bufPos + size
				with: bytes
				startingAt: 1.
			objectPosition := pos + bufPos bitShift: 1.
			activeDataFile == dataFileA 
				ifTrue: [each objectPosition: objectPosition]
				ifFalse: [each objectPosition: (objectPosition bitOr: 1)].
			bufPos := bufPos + size].
	stream
		atPosition: pos
			putBytesFrom: buf
			len: queueSize;
		flush.
	activeDataFile unlockAdding.
	byteStorageQueue do: [:each | each bytesStored].
	byteStorageQueue := OrderedCollection new.
	queueSize := 0
]

{ #category : #accessing }
ODBContainer >> id [

    ^id
]

{ #category : #'private-accessing' }
ODBContainer >> id: anInteger [

    id := anInteger
]

{ #category : #'private-accessing' }
ODBContainer >> indexFile [

    ^indexFile
]

{ #category : #private }
ODBContainer >> indexFileName [
	^ path / 'objects.idx'
]

{ #category : #public }
ODBContainer >> initHolders: holders [

    indexFile addHolders: holders
]

{ #category : #initialization }
ODBContainer >> initialize [
	dbFiles := WeakIdentityValueDictionary new.
	dbFilesMutex := Semaphore forMutualExclusion.
	byteStorageQueue := OrderedCollection new.
	queueSize := 0
]

{ #category : #public }
ODBContainer >> loadBytesAt: anInteger length: length [ 
	| byteArray stream bytesRead |
	(anInteger bitAnd: 1) == 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			stream := dataFileA stream]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			stream := dataFileB stream].
	byteArray := ByteArray new: length.
	bytesRead := stream 
				atPosition: (anInteger bitShift: -1)
				getBytesFor: byteArray
				len: length.
	bytesRead == length ifTrue: [^byteArray].
	^OmniBase signalError: 'Can not read object'
]

{ #category : #private }
ODBContainer >> localDefaultObjectSpace [
	^self convertToLocalObjectSpaceNumber: objectManager defaultObjectSpace
]

{ #category : #private }
ODBContainer >> lockDataFile [

    | currentSpace defaultSpace |

    currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
    defaultSpace := objectManager defaultObjectSpace.
    currentSpace == defaultSpace
        ifFalse:
            [defaultSpace == 0
                ifTrue:
                    [dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage
openOn: self dataFileNameA].
                    activeDataFile := dataFileA]
                ifFalse:
                    [dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage
openOn: self dataFileNameB].
                    activeDataFile := dataFileB].
            ].
	^ activeDataFile waitForAddingLock
]

{ #category : #public }
ODBContainer >> lockObjectSpace: anInteger [ 
	anInteger = 0 ifTrue: [dataFileA waitForAddingLock] ifFalse: [dataFileB waitForAddingLock]
]

{ #category : #accessing }
ODBContainer >> name [

    ^name
]

{ #category : #'private-accessing' }
ODBContainer >> name: aString [

    name := aString
]

{ #category : #public }
ODBContainer >> newObjectHolder [

    ^ODBObjectHolder new
        setContainer: self objectID: (ODBObjectID containerID: id index: 0)
]

{ #category : #public }
ODBContainer >> numberOfObjects [
		"Answer number of objects in container."

	^indexFile getLastIndex
]

{ #category : #public }
ODBContainer >> objectHoldersDo: aBlock [ 
	| objectHolder |
	indexFile indexesAndValuesDo: 
			[:index :value | 
			objectHolder := (ODBObjectHolder createOn: value) setContainer: self
						objectID: (ODBObjectID containerID: id index: index).
			aBlock value: objectHolder]
]

{ #category : #accessing }
ODBContainer >> objectManager [

    ^objectManager
]

{ #category : #private }
ODBContainer >> objectManager: anODBObjectManager [ 
	objectManager := anODBObjectManager
]

{ #category : #public }
ODBContainer >> onNewObjectFileDo: aBlock [ 
	| file newIndex |
	dbFilesMutex critical: 
			[newIndex := indexFile newObjectFileID.
			file := aBlock value: newIndex value: (self fileNameFromIndex: newIndex).
			file notNil 
				ifTrue: 
					[dbFiles at: newIndex put: file]].
	^file
]

{ #category : #public }
ODBContainer >> openObjectFile: index ifAbsentPut: aBlock [

	^ dbFilesMutex critical: [ 
		| file |
		file := dbFiles at: index ifAbsent: [ nil ].
		(file isNil or: [ file stream isNil ]) ifTrue: [ 
			file := aBlock value: (self fileNameFromIndex: index).
			dbFiles at: index put: file ]. 
		file]
]

{ #category : #accessing }
ODBContainer >> openOn: aString [ 
	path := aString.
	
	[indexFile := ODBObjectIndexFile openOn: self indexFileName.
	[dataFileA := ODBObjectStorage openOn: self dataFileNameA] on: Error do: [:ex | ].
	[dataFileB := ODBObjectStorage openOn: self dataFileNameB] on: Error do: [:ex | ].
	self localDefaultObjectSpace = 0 
		ifTrue: [(activeDataFile := dataFileA) isNil ifTrue: [activeDataFile := dataFileB]]
		ifFalse: [(activeDataFile := dataFileB) isNil ifTrue: [activeDataFile := dataFileA]].
	activeDataFile isNil 
		ifTrue: [OmniBase signalError: 'Object storage file ' , self dataFileNameA , ' can not be opened']] 
			ifCurtailed: [self close]
]

{ #category : #accessing }
ODBContainer >> path [ 
	^ path
]

{ #category : #'byte storage management' }
ODBContainer >> removeHolderAt: index [

	indexFile removeIndex: index
]

{ #category : #private }
ODBContainer >> removeObjectFile: anInteger [ 
	| file |
	dbFilesMutex critical: 
			[file := dbFiles at: anInteger ifAbsent: [^self].
			dbFiles removeKey: anInteger.
			file ifNotNil:[
				file close].
			(self fileNameFromIndex: anInteger) delete ]
]

{ #category : #private }
ODBContainer >> removeObjectSpace: anInteger [ 

	(self convertToLocalObjectSpaceNumber: anInteger) = 0 
		ifTrue: 
			[dataFileA isNil 
				ifFalse: 
					[activeDataFile == dataFileA ifTrue: [activeDataFile := dataFileB].
					dataFileA
						unlockAdding;
						removeAll;
						remove.
					dataFileA := nil]]
		ifFalse: 
			[dataFileB isNil 
				ifFalse: 
					[activeDataFile == dataFileB ifTrue: [activeDataFile := dataFileA].
					dataFileB
						unlockAdding;
						removeAll;
						remove.
					dataFileB := nil]]
]

{ #category : #private }
ODBContainer >> setNewObjectSpace: newSpace [ 
	| currentSpace newLocalSpace |

	newLocalSpace := self convertToLocalObjectSpaceNumber: newSpace.
	currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
	currentSpace = newLocalSpace ifTrue: [^self].
	newLocalSpace = 0 
		ifTrue: 
			[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
			activeDataFile := dataFileB]
]
