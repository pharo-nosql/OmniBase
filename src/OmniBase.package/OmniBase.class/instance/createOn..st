public
createOn: dirName 
	"Create new database. If a database already exists signal error."

	
	[rootDir := dirName.
	(ODBFileStream directoryExists: rootDir) 
		ifFalse: [ODBFileStream directoryCreate: rootDir].
	classManager := ODBClassManager new createOn: self.
	objectManager := ODBObjectManager new createOn: self.
	transactionManager := ODBTransactionManager new createOn: self.
	clientManager := ODBClientManager new createOn: self.
	self opened.
	clientManager localClient makeRootObject] 
			ifCurtailed: [self close]