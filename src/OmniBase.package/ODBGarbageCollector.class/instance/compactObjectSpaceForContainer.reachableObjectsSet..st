public
compactObjectSpaceForContainer: container reachableObjectsSet: set 
	"Private - Copy compact container objects space and remove objects which are not included in the set. If set is nil, then just compact the object space."

	| dbObject index count |
	count := 0.
	self progressNotification: 'Compacting container ' , container name value: 0.

	container objectHoldersDo: 
			[:holder | 
			count := count + 1.
			self progressNotification: nil value: count / container numberOfObjects.
			index := holder objectID index.
			dbObject := holder getObject.
			(set isNil or: [set includes: index]) 
				ifTrue: [dbObject garbageCollectOn: self]
				ifFalse: 
					[dbObject remove.
					container removeHolderAt: index]].

	container flushBytes