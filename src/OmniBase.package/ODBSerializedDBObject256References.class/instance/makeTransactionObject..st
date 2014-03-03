public/transaction processing
makeTransactionObject: aTransaction

	| mStream bytes referenceManager |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new
				createOn: bytes;
				position: ((referenceManager := ODBReferenceManager new) createMax256From: bytes).
	referenceManager transaction: aTransaction.
	^ODBSerializedObject new
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new
						deserializeFrom: mStream
						referenceManager: referenceManager
						transaction: aTransaction)
		transaction: aTransaction