private
storeNewObject: anObject inContainer: aContainer 
	"Store anObject into specified container."

	| transactionObject holder coll id |
	holder := aContainer newObjectHolder.
	anObject isODBTransactionObject 
		ifFalse: [transactionObject := ODBSerializedObject new value: anObject]
		ifTrue: [transactionObject := anObject].
	transactionObject setObjectHolder: holder transaction: self.
	cacheMutex critical: 
			[(id := aContainer id) > newObjects size 
				ifTrue: 
					[(coll := Array new: id) 
						replaceFrom: 1
						to: newObjects size
						with: newObjects
						startingAt: 1.
					newObjects := coll].
			(coll := newObjects at: id) isNil 
				ifTrue: 
					[coll := OrderedCollection new: 32.
					newObjects at: id put: coll].
			coll add: transactionObject.
			objectIndex at: anObject put: transactionObject].
	transactionObject objectStored