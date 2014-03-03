public
globalUnlock
	self lockTable.
	[self globalLockClientID: 0] ensure: [self unlockTable]