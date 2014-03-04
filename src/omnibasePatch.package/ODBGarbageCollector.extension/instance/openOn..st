*omnibasePatch
openOn: anOmniBase 
	"Open garbage collector on anOmnibase. If garbage collector file exists
	then previous garbage collection was interrupted.
	Answer <true> if previous GC was completed, <false> if it wasn't."

	objectManager := anOmniBase objectManager.
	(ODBFileStream exists: self gcFileName) 
		ifTrue: 
			[(gcFile := ODBGarbageCollectorFile openOn: self) isNil 
				ifFalse: 
					[gcFile status < 3 
						ifTrue: 
							[gcFile remove.
							gcFile := nil]]].
	^gcFile isNil