public
runOn: anOmniBase silentMode: silenceBool 
	"Run garbage collection on anOmniBase."

	objectManager := anOmniBase objectManager.
	[gcFile := ODBGarbageCollectorFile openOn: self gcFileName] on: Error
		do: 
			[:ex | 
			objectManager isLocked ifTrue: [OmniBase signalError: 'Object manager is locked !'].
			gcFile := ODBGarbageCollectorFile createOn: self gcFileName].
	^self run: silenceBool