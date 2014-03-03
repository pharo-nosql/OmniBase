public
isChanged
	"Answer true if changes were made to objects in this transaction."

	objectIndex do: [:transactionObject | transactionObject isChanged ifTrue: [^true]].
	^false