private
copyContainer: container 
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