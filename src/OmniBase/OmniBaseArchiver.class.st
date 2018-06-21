Class {
	#name : #OmniBaseArchiver,
	#superclass : #Object,
	#instVars : [
		'db',
		'newDb',
		'newVersionNumber',
		'oldHolders',
		'progressDialog',
		'progressValue',
		'versionDescriptor'
	],
	#category : 'OmniBase'
}

{ #category : #private }
OmniBaseArchiver >> copyClassManager [
	| lastClassId classDescription |
	self progressNotification: 'Copying class meta information' value: 0.
	lastClassId := db classManager lastClassId.
	1 to: lastClassId
		do: 
			[:i | 
			classDescription := nil.
			[classDescription := db classManager classDescriptionAt: i] on: Error do: [:ex | ].
			newDb classManager addClassDescription: classDescription withId: i.
			self progressNotification: nil value: i / lastClassId]
]

{ #category : #private }
OmniBaseArchiver >> copyContainer: container [ 
	| size newContainer newIndexFile dbClass |
	self progressNotification: 'Copying container ' , container name value: 0.
	newContainer := newDb objectManager containerAt: container id
				ifAbsent: [newDb objectManager containerNew: container name].
	newIndexFile := newContainer indexFile.
	newIndexFile setLastIndex: container indexFile getLastIndex.
	size := container numberOfObjects.
	container objectHoldersDo: 
			[:eachHolder | 
			eachHolder isRemoved 
				ifTrue: [newIndexFile removeIndex: eachHolder objectID index]
				ifFalse: 
					[[versionDescriptor versionOK: eachHolder versionNumber] 
						whileFalse: [eachHolder loadPreviousVersionFrom: oldHolders].
					eachHolder versionNumber: newVersionNumber.
					dbClass := ODBDatabaseObject persistentClassAt: eachHolder persistentClassID.
					dbClass hasBytes 
						ifTrue: 
							[eachHolder setContainer: newContainer.
							newContainer 
								addByteStorageRequest: (ODBGarbageCollectorRequest new objectHolder: eachHolder
										bytes: (container loadBytesAt: eachHolder objectPosition length: eachHolder objectLength))]
						ifFalse: 
							[dbClass hasExternalFiles 
								ifTrue: 
									["backup objects using external files (b-trees)"
									eachHolder getObject 
										createBackupCopyIn: newContainer
										versionDescriptor: versionDescriptor
										oldHolders: db transactionManager oldHolders
										versionNumber: newVersionNumber].
							newIndexFile at: eachHolder objectID index put: eachHolder contents]].
			self progressNotification: nil value: eachHolder objectID index / size].
	newContainer flushBytes
]

{ #category : #private }
OmniBaseArchiver >> copyContainers [
	| container i |
	i := 1.
	
	[container := db objectManager containerAt: i ifAbsent: [].
	i := i + 1.
	container isNil] 
			whileFalse: [self copyContainer: container]
]

{ #category : #public }
OmniBaseArchiver >> copyDatabase [
	self
		copyContainers;
		copyClassManager
]

{ #category : #public }
OmniBaseArchiver >> copyDatabase: silentBool [ 
	silentBool = true 
		ifTrue: [self copyDatabase]
		ifFalse: 
			['OmniBase on-line backup'
				displayProgressAt: Sensor cursorPoint
				from: 0 to: 100
				during:
					[:bar |
						progressDialog := bar.
						progressValue := bar.
						self copyDatabase]]
]

{ #category : #public }
OmniBaseArchiver >> onlineBackup: anOmniBase to: newPath [ 
	self 
		onlineBackup: anOmniBase
		to: newPath
		silent: false
]

{ #category : #public }
OmniBaseArchiver >> onlineBackup: anOmniBase to: newPath silent: silentBool [ 
	newDb := OmniBase createOn: newPath.
	
	[newDb objectManager reopenExclusively.
	db := anOmniBase.
	oldHolders := db transactionManager oldHolders.
	versionDescriptor := db transactionManager versionControl versionDescriptor copy.
	newVersionNumber := newDb transactionManager versionControl 
				getNewVersionNumberFor: newDb localClient clientID.
	newDb transactionManager versionControl removeCommittingFor: newDb localClient clientID.
	self copyDatabase: silentBool] 
			ensure: [newDb close]
]

{ #category : #private }
OmniBaseArchiver >> progressNotification: aString value: aFraction [ 
	progressDialog isNil 
		ifFalse: 
			[aFraction isNil ifFalse: [progressValue value: 100 * aFraction]].
]
