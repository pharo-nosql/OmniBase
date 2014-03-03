public/unclassified
getObjectIn: aTransaction

	objectSet == true ifTrue: [^object].
	^aTransaction objectAt: self objectID