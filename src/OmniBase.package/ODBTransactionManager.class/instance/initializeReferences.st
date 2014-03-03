private
initializeReferences
	"Private - Initialize dictionary of transaction references."

	transactionReferences := Array new: 4.
	transactionReferences
		at: 1 put: nil;
		at: 2 put: true;
		at: 3 put: false;
		at: 4 put: dbConnection