*omnibasePatch
basicAbort
	"Private - Abort transaction. After aborting it, it can not be used anymore."

	| changes |
	dbConnection isNil 
		ifFalse: 
			[locks isNil 
				ifFalse: 
					[(changes := transactionFile recovery) isNil 
						ifFalse: 
							[changes
								transaction: self;
								rollback.
							transactionFile recovery: nil].
					locks do: 
							[:each | 
							each
								transaction: self;
								unlock]].
			transactionManager transactionAborted: self.
			client transactionRemove: self].
	objects := nil.
	client := nil.
	dbConnection := nil.
	transactionManager := nil.

	objectIndex := nil.
	cacheMutex isNil 
		ifFalse: 
			[cacheMutex terminateProcess.
			cacheMutex := nil]