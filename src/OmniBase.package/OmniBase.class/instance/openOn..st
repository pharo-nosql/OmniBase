public
openOn: dirName 
	"Open an already existing database environment. 
	Trigger an exception if failed."

	
	[rootDir := dirName.
	classManager := ODBClassManager new openOn: self.
	objectManager := ODBObjectManager new openOn: self.
	transactionManager := ODBTransactionManager new openOn: self.
	clientManager := ODBClientManager new openOn: self.
	self opened] 
			ifCurtailed: [self close].
	self freeDiskSpace < 5242880 ifTrue: [OmniBase warningMessage: 'Low disk space !']