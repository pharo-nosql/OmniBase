public
commit: serializer 
	"Commit changes."

	| change newHolder |
	changed == true 
		ifTrue: 
			[newHolder := (holder makeNewVersion: transaction oldHolders)
						persistentClassID: ODBRootObjectDBHolder classID;
						versionNumber: transaction versionNumber;
						rootObjectID: (transaction getObjectID: dataBaseObject).
			change := (ODBNewObjectVersion new)
						setObjectID: holder objectID transactionObject: self;
						oldVersion: holder;
						newVersion: newHolder.
			transaction changesPackage add: change]