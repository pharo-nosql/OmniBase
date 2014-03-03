public
reorganizeBTree
	"Reorganize B-Tree dictionary."

	| newIterator assoc oldIndex |
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			oldIndex := objectHolder fileID.
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			
			[newIterator putSizeHolder: iterator getSizeHolder.
			assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[(ODBValueHolder createOn: assoc value) isRemoved 
						ifFalse: [newIterator goTo: assoc key put: assoc value].
					assoc := iterator getNext].
			newIterator close] 
					ifCurtailed: [newIterator remove].
			objectHolder store.
			iterator := nil].
	objectHolder container removeObjectFile: oldIndex