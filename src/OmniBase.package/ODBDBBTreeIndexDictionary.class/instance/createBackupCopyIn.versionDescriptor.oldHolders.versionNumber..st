public
createBackupCopyIn: newContainer versionDescriptor: versionDescriptor oldHolders: oldHolders versionNumber: versionNumber 
	"Create a backup copy of receiver in a newContainer."

	| newIterator assoc size realSize valueHolder |
	newContainer onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			size := iterator getSizeAt: versionDescriptor oldHolders: oldHolders.
			realSize := 0.
			
			[assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[valueHolder := ODBValueHolder createOn: assoc value.
					[versionDescriptor versionOK: valueHolder versionNumber] 
						whileFalse: [valueHolder loadPreviousVersionFrom: oldHolders].
					valueHolder isRemoved 
						ifFalse: 
							[realSize := realSize + 1.
							valueHolder versionNumber: versionNumber.
							newIterator goTo: assoc key put: valueHolder contents].
					assoc := iterator getNext].
			"realSize = size ifFalse: [OmniBase warningMessage: 'Cached dictionary size does not match real size']."
			newIterator putSizeHolder: ((ODBSizeHolder new)
						dictionarySize: realSize;
						previousVersionPosition: 0;
						versionNumber: versionNumber;
						yourself).
			newIterator close] 
					ifCurtailed: [newIterator remove].
			iterator := nil]