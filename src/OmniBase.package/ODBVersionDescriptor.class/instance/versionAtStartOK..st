public
versionAtStartOK: aVersionNumber 
	"Answer true if object with aVersionNumber can be read. 
	Current transaction commits are ignored."

	aVersionNumber <= readVersionNumber ifTrue: [^true].
	aVersionNumber <= topVersionNumber ifFalse: [^false].
	^(committingTransactions includes: aVersionNumber) not