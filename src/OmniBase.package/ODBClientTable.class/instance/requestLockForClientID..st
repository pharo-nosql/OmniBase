public
requestLockForClientID: clientID 
	"If global lock has not been set yet, mark that 
	clientID has requested transaction file to store locks. 
	Answer <true> if client can lock objects or <false> if not."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	self clientTableAt: clientID put: 10.
	^true] 
			ensure: [self unlockTable]