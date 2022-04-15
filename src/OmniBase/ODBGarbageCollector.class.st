Class {
	#name : #ODBGarbageCollector,
	#superclass : #Object,
	#instVars : [
		'containers',
		'gcFile',
		'objectManager',
		'progressDialog',
		'progressValue',
		'reorganizeDictionaries',
		'reorganizeIndexSets'
	],
	#category : #'OmniBase-GC'
}

{ #category : #private }
ODBGarbageCollector >> basicCompactContainerNamed: aString [ 
	| container |
	
	[container := objectManager containerNamed: aString
				ifAbsent: [OmniBase signalError: 'Container named ' , aString , ' does not exist'].
	(self checkDiskSpace: (Array with: container)) ifFalse: [^false].
	container
		createNewObjectSpace;
		swapObjectSpaces.
	self compactObjectSpaceForContainer: container reachableObjectsSet: nil] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]
]

{ #category : #private }
ODBGarbageCollector >> basicRun [
	
	[self progressNotification: 'Starting garbage collection' value: 0.
	self lockObjectManager.	"doesn't realy lock it, see method #lockObjectManager"
	containers := objectManager containers.
	(self checkDiskSpace: containers) ifFalse: [^false].
	self
		createNewObjectSpaces;
		selectNewObjectSpace;
		swapObjectSpaces;
		walkObjects;
		copyObjects;
		complete] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]
]

{ #category : #public }
ODBGarbageCollector >> checkDiskSpace: containersCollection [
	"Private - Check for avaiable disk space and set total number of objects in wait dialog."

	| maxContainerSize n gcSpace |
	maxContainerSize := 0.
	gcSpace := 0.
	containersCollection do: [ :container | 
		n := container numberOfObjects.
		gcSpace := n // 8 + gcSpace.
		maxContainerSize := container bytesAllocated max: maxContainerSize ].
	maxContainerSize + gcSpace < objectManager environment freeDiskSpace
		ifTrue: [ ^ true ].
	^ progressDialog
		ifNil: [ OmniBase warningMessage: '[OmniBase GC] Warning disk space low' ]
		ifNotNil: [ OmniBase confirmationMessage: 'Disk space low.
Are you sure you want to continue ?' ]
]

{ #category : #public }
ODBGarbageCollector >> close [
	gcFile ifNotNil: [ gcFile close ]
]

{ #category : #public }
ODBGarbageCollector >> compactObjectSpaceForContainer: container reachableObjectsSet: set [ 
	"Private - Copy compact container objects space and remove objects which are not included in the set. If set is nil, then just compact the object space."

	| dbObject index count |
	count := 0.
	self progressNotification: 'Compacting container ' , container name value: 0.

	container objectHoldersDo: 
			[:holder | 
			count := count + 1.
			self progressNotification: nil value: count / container numberOfObjects.
			index := holder objectID index.
			dbObject := holder getObject.
			(set isNil or: [set includes: index]) 
				ifTrue: [dbObject garbageCollectOn: self]
				ifFalse: 
					[dbObject remove.
					container removeHolderAt: index]].

	container flushBytes
]

{ #category : #private }
ODBGarbageCollector >> complete [
	"Private - Complete garbage collection."

	gcFile status = 6 ifFalse: [^self].
	objectManager environment transactionManager oldHolders truncate.
	objectManager unlock.
	gcFile remove.
	gcFile := nil
]

{ #category : #private }
ODBGarbageCollector >> copyObjects [
	"Private - Copy objects from oldObject space to new object space."

	| set objectSpace |
	gcFile status = 5
		ifFalse: [ ^ self ].
	objectSpace := objectManager defaultObjectSpace.
	containers do: [ :container | 
		[ set := ODBIntegerSet openOn: (self oidSetFilenameFor: container) ]
			on: Error
			do: [ set := nil ].
		set ifNotNil: [
			self
				compactObjectSpaceForContainer: container
				reachableObjectsSet: set.
			set remove.
			container removeObjectSpace: 1 - objectSpace ] ].
	gcFile status: 6
]

{ #category : #private }
ODBGarbageCollector >> createNewObjectSpaces [
	"Private - Create new object space for each container."

	gcFile status = 1 ifFalse: [ ^self ].
	containers do: [:each | each createNewObjectSpace ].
	"new object spaces created"
	gcFile status: 2
]

{ #category : #private }
ODBGarbageCollector >> gcFileName [
	^ objectManager environment path / 'GC.log'
]

{ #category : #private }
ODBGarbageCollector >> lockObjectManager [
	gcFile status = 0 ifFalse: [^self].
	"objectManager lock."	"don't lock it because db is already opened exclusively"
	"object manager has been locked"
	gcFile status: 1
]

{ #category : #private }
ODBGarbageCollector >> message: aString [ 
	OmniBase warningMessage: aString
]

{ #category : #private }
ODBGarbageCollector >> oidSetFilenameFor: anODBContainer [ 
	^ anODBContainer path / 'Marked.set'
]

{ #category : #private }
ODBGarbageCollector >> oidStackFileName [
	^ objectManager environment path / 'GC.oid'
]

{ #category : #public }
ODBGarbageCollector >> openOn: anOmniBase [ 
	"Open garbage collector on anOmnibase. If garbage collector file exists
	then previous garbage collection was interrupted.
	Answer <true> if previous GC was completed, <false> if it wasn't."

	objectManager := anOmniBase objectManager.
	(self gcFileName exists) 
		ifTrue: 
			[(gcFile := ODBGarbageCollectorFile openOn: self) isNil 
				ifFalse: 
					[gcFile status < 3 
						ifTrue: 
							[gcFile remove.
							gcFile := nil]]].
	^gcFile isNil
]

{ #category : #private }
ODBGarbageCollector >> progressNotification: aString value: aFraction [ 
	progressDialog isNil 
		ifFalse: 
			[aFraction isNil ifFalse: [progressValue value: 100 * aFraction]].
]

{ #category : #public }
ODBGarbageCollector >> reorganizeDictionaries [
	^reorganizeDictionaries == true
]

{ #category : #public }
ODBGarbageCollector >> reorganizeDictionaries: aBoolean [ 
	reorganizeDictionaries := aBoolean
]

{ #category : #public }
ODBGarbageCollector >> reorganizeIndexSets [
	"Answer <true> if B-Tree index sets should be reorganized."

	^reorganizeIndexSets == true
]

{ #category : #public }
ODBGarbageCollector >> reorganizeIndexSets: aBoolean [ 
	reorganizeIndexSets := aBoolean
]

{ #category : #public }
ODBGarbageCollector >> run [
	^self run: false
]

{ #category : #public }
ODBGarbageCollector >> run: shouldBeSilent [

	(objectManager environment globalLock
		and: [ objectManager reopenExclusively ])
		ifFalse: [ objectManager environment globalUnlock.
			self close.
			shouldBeSilent ifFalse: [
				OmniBase warningMessage: 
					'Database is still being accessed by other users !' ].
			^ false ].

	shouldBeSilent
		ifTrue: [ self basicRun ]
		ifFalse: [
			'OmniBase garbage collection in progress'
				displayProgressFrom: 0
				to: 100
				during: [ :bar | 
					progressDialog := bar.
					progressValue := bar.
					self basicRun ] ].
	^ true
]

{ #category : #public }
ODBGarbageCollector >> runOn: anOmniBase [ 
	"Run garbage collection on anOmniBase."

	^self runOn: anOmniBase silentMode: false
]

{ #category : #public }
ODBGarbageCollector >> runOn: anOmniBase silentMode: silenceBool [ 
	"Run garbage collection on anOmniBase."

	objectManager := anOmniBase objectManager.
	[ gcFile := ODBGarbageCollectorFile openOn: self gcFileName ] 
		on: Error
		do: [:ex | 
			objectManager isLocked ifTrue: [OmniBase signalError: 'Object manager is locked !'].
			gcFile := ODBGarbageCollectorFile createOn: self gcFileName ].
	^ self run: silenceBool
]

{ #category : #private }
ODBGarbageCollector >> selectNewObjectSpace [
	"Private - Select new object space."

	gcFile status = 2 ifFalse: [^self].
	gcFile newObjectSpace: 1 - objectManager defaultObjectSpace.
	gcFile status: 3
]

{ #category : #private }
ODBGarbageCollector >> swapObjectSpaces [
	"Private - Swap default object spaces."

	| newObjectSpace |
	gcFile status = 3 ifFalse: [^self].
	newObjectSpace := gcFile newObjectSpace.

	objectManager defaultObjectSpace == newObjectSpace 
		ifFalse: [
			containers do: [ :each |
				each lockObjectSpace: 1 - newObjectSpace ].
			objectManager defaultObjectSpace: newObjectSpace ].

	"object spaces have been swaped"
	gcFile status: 4
]

{ #category : #private }
ODBGarbageCollector >> walkObjectReferencesOf: objectID addInto: firstToDo oidSets: oidSets progressBlock: progressBlock [

	progressBlock value.
	(objectManager holderAt: objectID)
		ifNil: [ OmniBase signalError: 'Invalid object ID' ]
		ifNotNil: [ :holder | | dbObject |
			dbObject := holder getObject.
			dbObject referencesDo: [ :oid |
				| containerID |
				containerID := oid containerID.
				(containerID == 0 or: [
					(oidSets at: containerID) includes: oid index ])
					ifFalse: [
						(oidSets at: containerID) add: oid index.
						firstToDo add: oid.
						progressBlock value ] ].
			dbObject close ]
]

{ #category : #private }
ODBGarbageCollector >> walkObjects [
	"Private - Object traversal."

	| toDo firstToDo oidSets set totalObjects count progressBlock |
	gcFile status = 6 ifTrue: [ ^ self ].
	"create OID sets"
	oidSets := OrderedCollection new.
	"notifying progress count"
	count := 0.
	progressBlock := [
		self
			progressNotification: nil
			value: (count := count + 1) / (totalObjects * 2) ].
	
	[
		totalObjects := 0.
		containers do: [ :container | 
			set := ODBIntegerSet createOn: (self oidSetFilenameFor: container).
			[ oidSets size < container id ] whileTrue: [ oidSets add: nil ].
			oidSets at: container id put: set.
			totalObjects := totalObjects + container numberOfObjects ].

		self progressNotification: 'Traversing objects' value: 0.

		"first load all from rootObject"
		firstToDo := OrderedCollection new.
		"create OID stack"
		toDo := ODBObjectIdStack createOn: self oidStackFileName.
		"walk objects"
		(oidSets at: 1) add: 1.	"mark (1:1)"
		firstToDo add: (ODBObjectID containerID: 1 index: 1).

		[ firstToDo size = 1 ] whileTrue: [
			self
				walkObjectReferencesOf: firstToDo removeLast
				addInto: firstToDo
				oidSets: oidSets
				progressBlock: progressBlock ].

		firstToDo do: [ :eachOID | 
			self
				walkObjectReferencesOf: eachOID
				addInto: toDo
				oidSets: oidSets
				progressBlock: progressBlock ].

		[ toDo isEmpty ] whileFalse: [
			self
				walkObjectReferencesOf: toDo removeLast
				addInto: toDo
				oidSets: oidSets
				progressBlock: progressBlock ].
	
	] ensure: [
		"remove OID stack"
		toDo ifNotNil: [ toDo remove ].
		"close OID sets"
		oidSets do: [:each | each ifNotNil: [ each close ]]].

	gcFile status: 5
]
