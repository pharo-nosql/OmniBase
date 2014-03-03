public
start
	"Start transaction. Transaction is read-only 
	until no objects are locked."

	transactionManager transactionStart: self