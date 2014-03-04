public
abort
	"Abort transaction. After aborting it, it can not be used anymore."

	transactionManager isNil ifFalse: [transactionManager critical: [self basicAbort]].

	self triggerEvent: #finishedTransaction: with: self.
