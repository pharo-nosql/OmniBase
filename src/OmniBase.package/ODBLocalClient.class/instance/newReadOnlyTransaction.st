public/unclassified
newReadOnlyTransaction
		"Answer new read-only transaction for receiver."

	^ODBReadOnlyTransaction new
		setClient: self environment: clientManager environment;
		start