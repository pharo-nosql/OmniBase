public
garbageCollect
	"Garbage collect the database.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
	B-tree dictionaries will not be compacted."

	(ODBGarbageCollector new)
		reorganizeDictionaries: false;
		reorganizeIndexSets: false;
		runOn: self