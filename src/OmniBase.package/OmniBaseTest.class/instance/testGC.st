tests
testGC
	"Test garbage collection"

	| db |
	db := OmniBase openOn: self dir.
	self shouldnt: [db garbageCollect] raise: Error.
	db close