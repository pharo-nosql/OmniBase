public/transaction processing
makeTransactionObject: aTransaction

	| mStream bytes |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new createOn: bytes.
	^ODBSerializedObject new
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new
						deserializeFrom: mStream
						referenceManager: nil
						transaction: aTransaction)
		transaction: aTransaction