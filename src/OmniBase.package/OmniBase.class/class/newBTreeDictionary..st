public
newBTreeDictionary: keySize 
	"Factory method - create a new instance of a persistent B-tree dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent dictionary can store any object that implements #asBtreeKeyOfSize: as key, and any persistent object as its value."

	^ODBBTreeDictionary createWithKeyLength: keySize