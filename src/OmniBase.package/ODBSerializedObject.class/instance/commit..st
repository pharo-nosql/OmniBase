public
commit: serializer 
	"Commit changes."

	| change bytes referenceManager newHolder classID |
	changed == true ifFalse: [^self].
	referenceManager := ODBReferenceManager new.
	bytes := ODBMemoryWriteStream new.
	serializer 
		serialize: dataBaseObject odbObject
		onStream: bytes
		referenceManager: referenceManager
		classManager: transaction environment classManager.
	bytes := referenceManager asBytesWith: bytes asByteArray.
	classID := referenceManager databaseObjectClassID.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: classID;
				versionNumber: transaction versionNumber.
	newHolder storeBytes: bytes.
	change := (ODBNewObjectVersion new)
				setObjectID: holder objectID transactionObject: self;
				oldVersion: holder;
				newVersion: newHolder.
	transaction changesPackage add: change