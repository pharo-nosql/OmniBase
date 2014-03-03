public
reorganize
	"Reorganize database files.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
		- compact b-tree index files"

	(ODBGarbageCollector new)
		reorganizeDictionaries: true;
		reorganizeIndexSets: true;
		runOn: self