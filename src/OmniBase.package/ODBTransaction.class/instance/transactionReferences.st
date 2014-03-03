private
transactionReferences
	"Private - Answer collection of transaction dependent 
	objects and their object IDs (starting with 1000)."

	^(OrderedCollection new: 512)
		add: (Association key: self value: self odbObjectID);
		add: (Association key: dbConnection value: dbConnection odbObjectID);
		yourself