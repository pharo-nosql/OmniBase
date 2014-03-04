*omnibasePatch
lockDataFile

	"Dec, 2010 sas: this code was relying in evaluating a block that was happening only in win32
	but not in *nix. So now I'm making it wait for the lock and then execute the code normally
	because it seems the intention was the same."
	| currentSpace defaultSpace |

	activeDataFile waitForAddingLock.
	currentSpace := activeDataFile == dataFileA ifTrue: [0] ifFalse: [1].
	defaultSpace := objectManager defaultObjectSpace.
	currentSpace == defaultSpace 
		ifFalse: 
			[defaultSpace == 0 
				ifTrue: 
					[dataFileA isNil ifTrue: [dataFileA := ODBObjectStorage openOn: self dataFileNameA].
					activeDataFile := dataFileA]
				ifFalse: 
					[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage openOn: self dataFileNameB].
					activeDataFile := dataFileB].
			^self lockDataFile]