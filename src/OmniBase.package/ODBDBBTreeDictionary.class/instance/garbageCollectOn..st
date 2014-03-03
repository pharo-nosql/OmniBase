public
garbageCollectOn: anODBGarbageCollector 
	anODBGarbageCollector reorganizeDictionaries ifTrue: [self reorganizeBTree]