public
openOn: anObjectHolder 
	objectHolder := anObjectHolder.
	iterator := objectHolder container openObjectFile: objectHolder fileID
				ifAbsentPut: [:fileName | ODBBTreeIterator openOn: fileName]