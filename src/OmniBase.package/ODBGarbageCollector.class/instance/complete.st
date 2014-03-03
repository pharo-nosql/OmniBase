private
complete
	"Private - Complete garbage collection."

	gcFile status = 6 ifFalse: [^self].
	objectManager environment transactionManager oldHolders truncate.
	objectManager unlock.
	gcFile remove.
	gcFile := nil