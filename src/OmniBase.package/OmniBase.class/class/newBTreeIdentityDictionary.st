public
newBTreeIdentityDictionary
	"Factory method - create a new instance of a persistent B-tree identity dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent identity dictionary can store only persistent objects or nil as keys and persistent objects or nil as value."

	^ODBBTreeIdentityDictionary new