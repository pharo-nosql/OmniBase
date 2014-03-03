private
removeLoggedLock: aODBLock 
	"Private - Remove anODBLock from receiver and remove it from transaction file."

	locks remove: aODBLock ifAbsent: [].
	transactionFile lockRemove: aODBLock