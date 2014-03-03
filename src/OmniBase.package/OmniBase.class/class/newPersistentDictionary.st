public
newPersistentDictionary
	"Create new persistent dictionary. All dictionary keys will be 
	stored together with the dictionary if not already persistent. All
	dictionary values will be stored separately and will be made
	persistent each with its own object ID."

	| dict |
	dict := ODBPersistentDictionary new.
	self currentTransactionOrNil notNil ifTrue: [dict makePersistent].
	^dict