public
committed
	"Changes have been committed, update transaction object."

	dataBaseObject isNil ifFalse: [transactionObject setDataBaseObject: dataBaseObject].
	transactionObject objectCommitted