public
versionOK: aVersionNumber 
	"Answer true if object with aVersionNumber can be read."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber 
		ifTrue: [^(committingTransactions includes: aVersionNumber) not].
	myCommits isNil ifTrue: [^false].
	^myCommits includes: aVersionNumber