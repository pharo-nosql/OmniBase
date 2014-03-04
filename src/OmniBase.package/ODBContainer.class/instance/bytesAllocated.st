accessing
bytesAllocated
	| size1 size2 |
	size1 := 0.
	size2 := 0.
	dataFileA isNil ifFalse: [size1 := dataFileA size].
	dataFileB isNil ifFalse: [size2 := dataFileB size].
	^size1 + size2