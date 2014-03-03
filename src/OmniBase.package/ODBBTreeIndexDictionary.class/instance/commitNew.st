private
commitNew
	"Private - Commit changes when new database object needs to be created."

	| newHolder newDBObject vn |
	vn := transaction versionNumber.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: self databaseObjectClass classID;
				versionNumber: vn.
	newDBObject := self databaseObjectClass new createOn: newHolder keySize: keySize.
	changed notNil 
		ifTrue: 
			[changed keysAndValuesDo: 
					[:key :value | 
					value isRemoved 
						ifFalse: 
							[value
								objectID: (transaction getObjectID: value object);
								versionNumber: vn.
							newDBObject at: key put: value]]].
	(transaction changesPackage)
		add: ((ODBNewObjectVersion new)
					setObjectID: holder objectID transactionObject: self;
					oldVersion: holder;
					newVersion: newHolder);
		add: ((ODBDictionaryChanged new)
					transactionObject: self;
					dataBaseObject: newDBObject)