public
close
	dbFiles do: [:each | each isNil ifFalse: [each close]].
	indexFile isNil ifFalse: [indexFile close].
	dataFileA isNil ifFalse: [dataFileA close].
	dataFileB isNil ifFalse: [dataFileB close]