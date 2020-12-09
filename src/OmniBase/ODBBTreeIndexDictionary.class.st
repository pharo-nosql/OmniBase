Class {
	#name : #ODBBTreeIndexDictionary,
	#superclass : #ODBTransactionObject,
	#instVars : [
		'changed',
		'currentKey',
		'keySize'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBBTreeIndexDictionary class >> createWithKeyLength: keyLength [
        "Answer new instance of dictionary with max keyLength characters for keys."

    ^self new keySize: keyLength
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> at: aKey [

    ^self at: aKey ifAbsent: []
]

{ #category : #public }
ODBBTreeIndexDictionary >> at: aKey ifAbsent: aBlock [ 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^aBlock value].
	value isRemoved ifTrue: [^aBlock value].
	^value getObjectIn: transaction
]

{ #category : #public }
ODBBTreeIndexDictionary >> at: aKey ifAbsentPut: aBlock [ 
	^ self at: aKey ifAbsent: [self at: aKey put: aBlock value]
]

{ #category : #public }
ODBBTreeIndexDictionary >> at: aKey put: anObject [ 
	"Associate aKey with anObject. Answer anObject."

	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key.
	value object: anObject.
	changed isNil ifTrue: [changed := self newChangedDictionary].
	changed at: key put: value.
	^anObject
]

{ #category : #private }
ODBBTreeIndexDictionary >> basicGoTo: aByteArray [ 
	currentKey := aByteArray.
	changed isNil ifFalse: [changed goTo: currentKey]
]

{ #category : #private }
ODBBTreeIndexDictionary >> bytesFromKey: anObject [ 
	^anObject asBtreeKeyOfSize: keySize
]

{ #category : #private }
ODBBTreeIndexDictionary >> commit: serializer [ 
	"Commit changes."

	dataBaseObject isNil ifTrue: [self commitNew] ifFalse: [self commitChanged]
]

{ #category : #private }
ODBBTreeIndexDictionary >> commitChanged [
	"Private - Commit changes on an already existing dictionary."

	| changesPackage newValue vn oldHolders |
	changesPackage := transaction changesPackage.
	changesPackage add: (ODBDictionaryChanged new transactionObject: self).
	vn := transaction versionNumber.
	oldHolders := transaction oldHolders.
	changed isNil 
		ifFalse: 
			[changed keysAndValuesDo: 
					[:key :oldValue | 
					newValue := oldValue makeNewVersion: oldHolders.
					newValue versionNumber: vn.
					oldValue isRemoved 
						ifFalse: [newValue objectID: (transaction getObjectID: newValue object)].
					changesPackage add: ((ODBAssociationChanged new)
								key: key;
								setObjectID: holder objectID transactionObject: self;
								oldValue: oldValue;
								newValue: newValue)]]
]

{ #category : #private }
ODBBTreeIndexDictionary >> commitNew [
	"Private - Commit changes when new database object needs to be created."

	| newHolder newDBObject vn |
	vn := transaction versionNumber.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: self databaseObjectClass classID;
				versionNumber: vn.
	newDBObject := self databaseObjectClass new createOn: newHolder keySize: keySize.
	changed notNil 
		ifTrue: 
			[changed keysAndValuesDo: 
					[:key :value | 
					value isRemoved 
						ifFalse: 
							[value
								objectID: (transaction getObjectID: value object);
								versionNumber: vn.
							newDBObject at: key put: value]]].
	(transaction changesPackage)
		add: ((ODBNewObjectVersion new)
					setObjectID: holder objectID transactionObject: self;
					oldVersion: holder;
					newVersion: newHolder);
		add: ((ODBDictionaryChanged new)
					transactionObject: self;
					dataBaseObject: newDBObject)
]

{ #category : #private }
ODBBTreeIndexDictionary >> databaseObjectClass [
	^ODBDBBTreeIndexDictionary
]

{ #category : #private }
ODBBTreeIndexDictionary >> dbPeekNext [
	| iterator assoc valueHolder |
	dataBaseObject isNil ifTrue: [^nil].
	iterator := dataBaseObject iterator.
	"critical section begin"
	iterator critical: 
			[iterator goTo: currentKey.
			
			[(assoc := iterator getNext) isNil ifTrue: [^nil].
			valueHolder := ODBValueHolder createOn: assoc value.
			[transaction versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved] 
					whileTrue: []].
	"critical section end"
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: assoc key)
		value: valueHolder
]

{ #category : #private }
ODBBTreeIndexDictionary >> dbPeekPrevious [
	| iterator assoc valueHolder |
	dataBaseObject isNil ifTrue: [^nil].
	iterator := dataBaseObject iterator.
	"critical section begin"
	iterator critical: 
			[iterator goTo: currentKey.
			
			[(assoc := iterator getPrevious) isNil ifTrue: [^nil].
			valueHolder := ODBValueHolder createOn: assoc value.
			[transaction versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved] 
					whileTrue: []].
	"critical section end"
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: assoc key)
		value: valueHolder
]

{ #category : #public }
ODBBTreeIndexDictionary >> do: aBlock [ 
	"Evaluate aBlock for each object in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could take some time."

	| assoc |
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[aBlock value: assoc value.
			assoc := self getNext]
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> first [

	^ self getFirst
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> first: anInteger [

	| assoc result |
	
	result := OrderedCollection new.
	self basicGoTo: (ByteArray new: keySize).
	assoc := self getNext.
	assoc isNil ifTrue:[^#()].
	result add: assoc value.
	
	1 to: (anInteger -1) do:[:i| |current|
		current := self getNext.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
]

{ #category : #public }
ODBBTreeIndexDictionary >> forKeysStartingWith: aStringOrByteArray do: aBlock [ 
	"Evaluate aOneArgumentBlock for every key that starts with aStringOrByteArray."

	| fromKey toKey assoc |
	fromKey := self bytesFromKey: aStringOrByteArray.
	toKey := fromKey copy.
	aStringOrByteArray size + 1 to: keySize do: [:i | toKey at: i put: 255].
	self basicGoTo: fromKey.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc value.
			assoc := self getNext]
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> from: start to: end [
	"Returns occurrences from start to end."

	| assoc result cursor startKey endKey current |
	result := OrderedCollection new..
	startKey := self bytesFromKey: start.
	endKey := self bytesFromKey: end.
	self basicGoTo: startKey.
	assoc := self getCurrent.

	[currentKey asInteger <= endKey asInteger] whileTrue:[
		assoc ifNotNil:[
			result add: assoc value].
		current := self getNext].
	
	^ result
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> fromPosition: start to: end [
	"Returns occurrences from start to end."
	
	"Better implementations of this are very welcome :)"

	| assoc result cursor startKey endKey current |
	result := OrderedCollection new..
	startKey := self bytesFromKey: start.
	endKey := self bytesFromKey: end.
	self basicGoTo: startKey.
	assoc := self getCurrent.
	assoc ifNil:[^ result].

	[currentKey asInteger <= endKey asInteger] whileTrue:[
		assoc ifNotNil:[
			result add: assoc value].
		current := self getNext.
		current isNil ifTrue: [^result]].
	
	^ result
]

{ #category : #enumerating }
ODBBTreeIndexDictionary >> getCurrent [
	| a |
	changed isNil 
		ifFalse: 
			[(a := changed getCurrent) isNil 
				ifFalse: 
					[a valueHolder isRemoved ifTrue: [^nil].
					^a]].
	(dataBaseObject isNil 
		or: [(a := dataBaseObject iterator goToAndGetCurrentAt: currentKey) isNil]) ifTrue: [^nil].
	a := ODBValueHolder createOn: a value.
	[transaction versionDescriptor versionOK: a versionNumber] 
		whileFalse: [a loadPreviousVersionFrom: transaction oldHolders].
	a isRemoved ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: currentKey)
		value: a
]

{ #category : #public }
ODBBTreeIndexDictionary >> getFirst [
	| assoc |
	self basicGoTo: (ByteArray new: keySize).
	(assoc := self getCurrent) isNil ifTrue: [^self getNext].
	^assoc
]

{ #category : #public }
ODBBTreeIndexDictionary >> getLast [
	| assoc |
	self basicGoTo: ((ByteArray new: keySize) atAllPut: 255).
	(assoc := self getCurrent) isNil ifTrue: [^self getPrevious].
	^assoc
]

{ #category : #enumerating }
ODBBTreeIndexDictionary >> getNext [
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekNext) isNil] whileFalse: 
					[((a2 := self dbPeekNext) notNil and: [a2 < a1]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToNext.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekNext) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2
]

{ #category : #enumerating }
ODBBTreeIndexDictionary >> getPrevious [
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekPrevious) isNil] whileFalse: 
					[((a2 := self dbPeekPrevious) notNil and: [a1 < a2]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToPrevious.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekPrevious) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2
]

{ #category : #public }
ODBBTreeIndexDictionary >> goTo: aKey [ 
	self basicGoTo: (self bytesFromKey: aKey)
]

{ #category : #public }
ODBBTreeIndexDictionary >> includesKey: aKey [ 
	| value |
	value := self valueAt: (self bytesFromKey: aKey) ifAbsent: [^false].
	^value isRemoved not
]

{ #category : #private }
ODBBTreeIndexDictionary >> initialize [
	"Private - Initialize receiver."

	super initialize.
	keySize := 32
]

{ #category : #public }
ODBBTreeIndexDictionary >> isChanged [
	"Answer <true> if object has been changed."

	^changed notNil or: [dataBaseObject isNil]
]

{ #category : #public }
ODBBTreeIndexDictionary >> isEmpty [
	^self size = 0
]

{ #category : #private }
ODBBTreeIndexDictionary >> keyFromBytes: aByteArray [ 
	^aByteArray
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> keyLength [

    ^keySize
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> keySize [ 

	^ keySize 
]

{ #category : #private }
ODBBTreeIndexDictionary >> keySize: anInteger [ 
	"Private - Set the key upon creation size."

	keySize := anInteger.
	(keySize < 300 and: [keySize > 1]) 
		ifFalse: [OmniBase signalError: 'Please choose key size between 2 and 300 bytes']
]

{ #category : #public }
ODBBTreeIndexDictionary >> keysFrom: key1 to: key2 do: aBlock [ 
	"Evaluate aBlock for each key in the given key range."

	| toKey assoc |
	toKey := self bytesFromKey: key2.
	self goTo: key1.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc key.
			assoc := self getNext]
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> last: anInteger [

	| assoc result |
	
	result := OrderedCollection new.

	self basicGoTo: ((ByteArray new: keySize) atAllPut: 255).
	(assoc := self getCurrent) isNil ifTrue: [
		assoc := self getPrevious].

	assoc isNil ifTrue:[^#()].
	result add: assoc value.
	
	1 to: (anInteger -1) do:[:i| |current|
		current := self getPrevious.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
]

{ #category : #initialization }
ODBBTreeIndexDictionary >> newChangedDictionary [

    ^ODBSortedDictionary new
]

{ #category : #private }
ODBBTreeIndexDictionary >> objectCommitted [
	"Private - Changes have been committed, update object."

	changed := nil
]

{ #category : #accessing }
ODBBTreeIndexDictionary >> oldFromPosition: start to: end [
	"Returns occurrences from start to end."
	
	"Better implementations of this are very welcome :)"

	| assoc result cursor |

	result := OrderedCollection new.
	self basicGoTo: (ByteArray new: keySize).
	assoc := self getFirst.

	start = 1 ifTrue:[
		result add: assoc value].
	
	"jump to the position"
	cursor := 1.
	[cursor = start] whileFalse:[
		assoc := self getNext.
		cursor := cursor + 1.
		cursor = start ifTrue:[
			result add: assoc value]].

	"collect from start to end"
	start to: end do:[:i| |current|
		current := self getNext.
		current isNil ifTrue: [^result].
		result add: current value].
	
	^ result
]

{ #category : #public }
ODBBTreeIndexDictionary >> removeKey: aKey [ 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^nil].
	value isRemoved 
		ifFalse: 
			[value removed.
			changed isNil ifTrue: [changed := self newChangedDictionary].
			changed at: key put: value]
]

{ #category : #public }
ODBBTreeIndexDictionary >> selectKeysFrom: prefix1 to: prefix2 [ 
	"Select all keys between prefix1 and prefix2."

	| toKey keys |
	keys := OrderedCollection new.
	prefix1 size > keySize ifTrue: [^keys].
	toKey := prefix2 , ((String new: keySize - prefix2 size) atAllPut: 255 asCharacter).
	self 
		keysFrom: prefix1
		to: toKey
		do: [:key | keys add: key].
	^keys
]

{ #category : #public }
ODBBTreeIndexDictionary >> selectKeysStartingWith: aString [ 
	"Select all keys that start with aString."

	| toKey keys |
	keys := OrderedCollection new.
	aString size > keySize ifTrue: [^keys].
	toKey := aString , ((String new: keySize - aString size) atAllPut: 255 asCharacter).
	self 
		keysFrom: aString
		to: toKey
		do: [:key | keys add: key].
	^keys
]

{ #category : #public }
ODBBTreeIndexDictionary >> transactionAssociationsDo: aBlock [ 
	"Evaluate a block for each association in dictionary.
        New transaction will be created for each key."

	| subTransaction valueHolder versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject associationsDo: 
			[:assoc | 
			valueHolder := assoc value.
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction
						value: (Association key: assoc key
								value: (subTransaction referenceAt: valueHolder objectID)).
					subTransaction abort]]
]

{ #category : #public }
ODBBTreeIndexDictionary >> transactionDo: aBlock [ 
	"Evaluate a block for every object in dictionary.
        New transaction will be created for each key+value pair."

	| subTransaction client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransaction.
					"take new version descriptor"
					versionDescriptor := subTransaction versionDescriptor.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]
]

{ #category : #public }
ODBBTreeIndexDictionary >> transactionReadOnlyDo: aBlock [ 
	"Evaluate a block for every object in dictionary.
	New transaction will be created for each key+value pair."

	| subTransaction versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]
]

{ #category : #public }
ODBBTreeIndexDictionary >> transactionValueBlocksDo: aBlock [ 
	"Evaluate a block for every 100 objects in dictionary.
        New transaction is created each time aBlock is evaluated."

	| subTransaction objects count client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	client := transaction client.
	count := 0.
	objects := OrderedCollection new: 40.
	subTransaction := client newTransaction.
	"take new version descriptor"
	versionDescriptor := subTransaction versionDescriptor.
	
	[dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[objects add: (subTransaction objectAt: valueHolder objectID).
					(count := count + 1) == 40 
						ifTrue: 
							[aBlock value: subTransaction value: objects.
							subTransaction abort.
							count := 0.
							objects := OrderedCollection new: 40.
							subTransaction := client newTransaction.
							"take new version descriptor"
							versionDescriptor := subTransaction versionDescriptor]]].
	count > 0 ifTrue: [aBlock value: subTransaction value: objects]] 
			ensure: [subTransaction abort]
]

{ #category : #private }
ODBBTreeIndexDictionary >> valueAt: key [ 
	"Private - Answer persistent object value at key  with right version loaded."

	^self valueAt: key ifAbsent: [ODBValueHolder new]
]

{ #category : #private }
ODBBTreeIndexDictionary >> valueAt: aKey ifAbsent: aBlock [ 
	"Private - Answer correct version of value holder at aKey, evaluate aBlock if absent."

	| value |
	changed isNil 
		ifFalse: 
			[value := changed at: aKey.
			value isNil ifFalse: [^value]].
	dataBaseObject isNil ifTrue: [^aBlock value].
	(value := dataBaseObject iterator goToAndGetCurrentAt: aKey) isNil 
		ifTrue: [^aBlock value].
	value := ODBValueHolder createOn: value value.
	[transaction versionDescriptor versionOK: value versionNumber] 
		whileFalse: [value loadPreviousVersionFrom: transaction oldHolders].
	^value
]

{ #category : #public }
ODBBTreeIndexDictionary >> values [
	"Answer collection of all objects in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could block your image for some time."

	| coll assoc |
	coll := OrderedCollection new.
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[coll add: assoc value.
			assoc := self getNext].
	^coll
]
