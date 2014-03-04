public
checkpoint
	"Checkpoint transaction i.e. write all persistent objects that are marked as dirty or new into database.
	Only changes are written into the database. This is an atomic operation which will either complete successfully
	or fail completely with no changes whatsoever written into the database. After writing changes all locks on already
	existing object will still be set. Objects that were new, had no locks set and are thus not locked. Transaction can
	be checkpointed more than once. As seen below the whole process of writing changes into the database (files)
	is executed using a semaphore therefore only one transaction per database session can write its changes at a time."

	self isInconsistent ifTrue: [OmniBase signalError: 'Transaction is inconsistent'].
	transactionManager ifNil:[ODBTransactionCanNotCommit signal].
	
	transactionManager critical: 
			[[self prepare] ifCurtailed: 
					[self becomeInconsistent.
					transactionManager transactionCommitEnd: self].
			[changesPackage commit] ifCurtailed: 
					[self
						becomeInconsistent;
						basicAbort]].
	self committed