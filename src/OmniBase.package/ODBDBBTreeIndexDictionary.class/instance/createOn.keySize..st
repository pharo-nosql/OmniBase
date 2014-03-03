public
createOn: anObjectHolder keySize: anInteger 
	objectHolder := anObjectHolder.
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			iterator := (ODBBTreeIterator new)
						keyLength: anInteger;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName]