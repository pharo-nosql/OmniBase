public
garbageCollectOn: anODBGarbageCollector 
	anODBGarbageCollector reorganizeIndexSets ifTrue: [self reorganizeBTree]