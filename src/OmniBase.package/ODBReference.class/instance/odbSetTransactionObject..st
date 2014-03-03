accessing
odbSetTransactionObject: anODBTransactionObject 
	"Private - Set transaction object and answer its value."

	transactionObject := anODBTransactionObject.
	^demandLoader := transactionObject value