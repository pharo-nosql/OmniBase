private
signalLockingConflictAt: anObject 
	"Private - anObject could not have been locked. 
	Signal an error."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject
				ifAbsent: [OmniBase signalError: 'Internal locking error'].
	transactionObject objectHolder oldVersion 
		ifTrue: 
			[ODBCannotLockObject signal: 'Object has already been changed in another transaction']
		ifFalse: [ODBCannotLockObject signal: 'Object is already locked in another transaction']