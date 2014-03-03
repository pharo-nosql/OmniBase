public
setGlobalLockFor: clientID 
	"Try to global lock database. Answer <true> if successfull."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == 0 ifFalse: [^false].
	1 to: self class maxClients do: [:i | (self clientTableAt: i) == 10 ifTrue: [^false]].
	self globalLockClientID: clientID.
	^true] 
			ensure: [self unlockTable]