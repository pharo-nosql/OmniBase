private
versionNumber: anInteger 
	"Private - Set version number."

	| index |
	(versionNumber := anInteger) isNil 
		ifFalse: 
			[myCommits isNil ifTrue: [myCommits := OrderedCollection new: 4].
			(index := committingTransactions indexOf: anInteger) == 0 
				ifFalse: [committingTransactions at: index put: -1].
			myCommits add: anInteger]