private
prepare
	"Private - Prepare for commit."

	| serializer coll holder array index allObjects lastSize notFirstPass |
	allObjects := IdentitySet new: objectIndex size.
	notFirstPass := false.
	"send #odbAboutToCommitIn: to every persistent object in cache"
	"if any object stores additional objects do it again for new objects"
	
	[lastSize := objectIndex size.
	objectIndex values do: 
			[:each | 
			(notFirstPass and: [allObjects includes: each]) 
				ifFalse: 
					[each odbAboutToCommitIn: self.
					allObjects add: each]].
	lastSize = objectIndex size] 
			whileFalse: [notFirstPass := true].
	cacheMutex critical: 
			["initialize object ID indexes for new objects & lock & store them"
			1 to: newObjects size
				do: 
					[:i | 
					(coll := newObjects at: i) isNil 
						ifFalse: 
							[array := Array new: coll size.
							index := 0.
							coll do: 
									[:each | 
									index := index + 1.
									holder := each objectHolder.
									array at: index put: holder].
							holder container initHolders: array.
							coll do: [:each | objects at: each objectHolder objectID put: each].
							newObjects at: i put: nil]].
			self lockID isNil 
				ifTrue: [OmniBase signalError: 'Database is globaly locked by another user'].
			"make reference map"
			serializer := ODBSerializer new.
			self transactionReferences 
				do: [:each | serializer addExternalReference: each key objectId: each value].
			objectIndex 
				keysAndValuesDo: [:key :value | serializer addExternalReference: key objectId: value objectID]].
	"get new version number"
	transactionManager transactionCommitBegin: self.
	transactionFile versionNumber: versionDescriptor versionNumber.
	"collect changes on transaction objects"
	changesPackage := ODBChangesPackage new.
	allObjects do: [:transactionObject | transactionObject commit: serializer].
	dbConnection objectManager flushContainers.
	self oldHolders flush.
	transactionFile recovery: changesPackage