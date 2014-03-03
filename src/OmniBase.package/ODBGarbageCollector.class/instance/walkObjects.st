private
walkObjects
	"Private - Object traversal."

	| toDo firstToDo oidSets set containerID totalObjects objectID holder dbObject count |
	gcFile status = 6 ifTrue: [^self].
	"create OID sets"
	oidSets := OrderedCollection new.
	
	[totalObjects := 0.
	containers do: 
			[:container | 
			set := ODBIntegerSet createOn: (self oidSetFilenameFor: container).
			[oidSets size < container id] whileTrue: [oidSets add: nil].
			oidSets at: container id put: set.
			totalObjects := totalObjects + container numberOfObjects].
	count := 0.
	self progressNotification: 'Traversing objects' value: 0.
	"first load all from rootObject"
	firstToDo := OrderedCollection new.
	"create OID stack"
	toDo := ODBObjectIdStack createOn: self oidStackFileName.
	"walk objects"
	(oidSets at: 1) add: 1.	"mark (1:1)"
	firstToDo add: (ODBObjectID containerID: 1 index: 1).
	[firstToDo size = 1] whileTrue: 
			[objectID := firstToDo removeLast.
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: objectID) isNil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									firstToDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']].
	firstToDo do: 
			[:eachOID | 
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: eachOID) == nil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									toDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']].
	[toDo isEmpty] whileFalse: 
			[objectID := toDo removeLast.
			self progressNotification: nil value: (count := count + 1) / (totalObjects * 2).
			(holder := objectManager holderAt: objectID) == nil 
				ifFalse: 
					[dbObject := holder getObject.
					dbObject referencesDo: 
							[:oid | 
							containerID := oid containerID.
							(containerID == 0 or: [(oidSets at: containerID) includes: oid index]) 
								ifFalse: 
									[(oidSets at: containerID) add: oid index.
									toDo add: oid.
									self progressNotification: nil value: (count := count + 1) / (totalObjects * 2)]].
					dbObject close]
				ifTrue: [OmniBase signalError: 'Invalid object ID']]] 
			ensure: 
				["remove OID stack"
				toDo isNil ifFalse: [toDo remove].
				"close OID sets"
				oidSets do: [:each | each notNil ifTrue: [each close]]].
	gcFile status: 5