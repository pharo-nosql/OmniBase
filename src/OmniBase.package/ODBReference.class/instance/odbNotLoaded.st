private
odbNotLoaded
		"Answer <true> if the referenced object has not been loaded yet."

	transactionObject notNil ifTrue: [^false].
	^(demandLoader transaction cachedObjectAt: demandLoader odbObjectID) isNil