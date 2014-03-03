public
rollback
	"Rollback changes."

	| currentHolder |
	(currentHolder := transaction objectHolderAt: objectID) isNil ifTrue: [^self].
	currentHolder versionNumber > newVersion versionNumber 
		ifFalse: 
			[currentHolder
				contents: oldVersion contents;
				store]