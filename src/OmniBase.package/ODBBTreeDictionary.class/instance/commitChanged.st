private
commitChanged
	"Private - Commit changes on an already existing dictionary."

	| changesPackage newValue vn oldHolders |
	changesPackage := transaction changesPackage.
	changesPackage add: (ODBDictionaryChanged new transactionObject: self).
	deltaSize = 0 
		ifFalse: 
			[changesPackage add: ((ODBSizeChanged new)
						setObjectID: holder objectID transactionObject: self;
						deltaSize: deltaSize)].
	vn := transaction versionNumber.
	oldHolders := transaction oldHolders.
	changed isNil 
		ifFalse: 
			[changed keysAndValuesDo: 
					[:key :oldValue | 
					newValue := oldValue makeNewVersion: oldHolders.
					newValue versionNumber: vn.
					oldValue isRemoved 
						ifFalse: [newValue objectID: (transaction getObjectID: newValue object)].
					changesPackage add: ((ODBAssociationChanged new)
								key: key;
								setObjectID: holder objectID transactionObject: self;
								oldValue: oldValue;
								newValue: newValue)]]