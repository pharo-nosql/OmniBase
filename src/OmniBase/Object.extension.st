Extension { #name : #Object }

{ #category : #'*omnibase' }
Object >> asBtreeKeyOfSize: keySize [

	OmniBase signalError: 'Dont know how to convert this object to a B-tree dictionary bytes key'
]

{ #category : #'*omnibase' }
Object >> commit: serializer [
	"do nothing"

]

{ #category : #'*omnibase' }
Object >> isIdenticalTo: anObject [ 
	"Answer true if anObject is identical to receiver. This is necessary since with database
	proxies the real object identity is lost because while the object is not yet loaded from the
	database it is represented by its proxy. Later when the real object is loaded this proxy still
	represents the identical object but the #== identity check will answer false because it is not
	aware of this. It is implemented in this way because the #== method is inlined and can not
	be overridden."

	anObject isODBReference ifTrue: [^anObject isIdenticalTo: self].
	^self == anObject
]

{ #category : #'*omnibase' }
Object >> isImmediate [
	^false
]

{ #category : #'*omnibase' }
Object >> isODBExpired [ 

	^ false
]

{ #category : #'*omnibase' }
Object >> isODBPersistent [

	^ self currentTransaction isPersistent: self
]

{ #category : #'*omnibase' }
Object >> isODBReference [

	^false
]

{ #category : #'*omnibase' }
Object >> isODBTransactionObject [

	^false
]

{ #category : #'*omnibase' }
Object >> makePersistent [
	"Makes the object persistent in the current process's transaction.
	Note: because is not specifiying where, this instance is going to 
	be persisted in the default container."

	"Note: using a dynamic variable could allow to still use the #makePersistent message
	while deciding somewhere else in which container this should be stored.
	It would look like:
	ARCurrentContainer value isNil
		ifTrue:[OmniBase currentTransaction makePersistent: self]
		ifFalse:[OmniBase currentTransaction makePersistent: self in: ARCurrentContainer value]"
	
	OmniBase currentTransaction makePersistent: self
		
]

{ #category : #'*omnibase' }
Object >> markDirty [
	| t |
	(t := OmniBase currentTransactionOrNil) isNil 
		ifTrue: 
			[(t := self odbGetTransaction) isNil 
				ifTrue: 
					[OmniBase signalError: 'Can not mark object as dirty. Transaction context is unknown. ']].
	t markDirty: self
]

{ #category : #'*omnibase' }
Object class >> newPersistent [

	^self new makePersistent
]

{ #category : #'*omnibase' }
Object >> odbAboutToCommitIn: anOmniBaseTransaction [ 
	"Sent before transaction writes changes to the database (right before commit).
	In this method you can use transaction the same way as usual.
	Do nothing by default."

	
]

{ #category : #'*omnibase' }
Object >> odbBasicSerialize: serializer [

	| stream classInfo instSize |
	classInfo := serializer registerClass: self class.
	stream := serializer stream.
	classInfo isVariable ifTrue: [ stream putPositiveInteger: self basicSize ].
	classInfo isBytes ifFalse: [
		classInfo instVarIndexes do: [:i | (self instVarAt: i) odbSerialize: serializer ].
		instSize := self class instSize.
		instSize + 1 to: instSize + self basicSize do: [:i | 
			(self instVarAt: i) odbSerialize: serializer ].
		^self].
	"variable - need to check whether we have bytes or words"
	self class isWords
		ifFalse: [ stream putBytesFrom: self len: self basicSize ]
		ifTrue: [1 to: self basicSize do: [:i | stream putInteger: (self basicAt: i)]].
]

{ #category : #'*omnibase' }
Object >> odbDeserialize: deserializer [

	^self
]

{ #category : #'*omnibase' }
Object >> odbDeserialized: deserializer [

	^self
]

{ #category : #'*omnibase' }
Object >> odbGetOID [
	"Answer persistent object's OID."

	| t oid |
	(oid := self odbObjectID) isNil ifFalse: [^oid].
	(t := OmniBase currentTransactionOrNil) isNil 
		ifFalse: [(oid := t getObjectIDOrNil: self) isNil ifFalse: [^oid]].

	"sas: declared that bug when trying #odbGetTransaction on some odb reference that's a subinstance
	of this persistent and fails due to strangeness in instVars is an irrelevant, inconsequent mistery that
	only complicates one case that isn't that important after all. So I'm commenting the following lines:
	
	t isAborted ifTrue:[^ nil]."
	"(t := self odbGetTransaction) isNil ifFalse: [^t getObjectIDOrNil: self]."
	^nil
]

{ #category : #'*omnibase' }
Object >> odbGetTransaction [
	"Answer the transaction in which the object was loaded."

	"immediate objects can not be made persistent"

	| allReferences |
	self isImmediate ifTrue: [^nil].

	"first check all inst vars if any references a proxy from which we could get a reference to transaction"
	self class isBits
		ifFalse: 
			[1 to: self class instSize + self basicSize
				do: [:i | (self instVarAt: i) isODBReference ifTrue: [^(self instVarAt: i) odbTransaction]]].

	"check references to self and find the transaction in which object was loaded"	
	"allReferences := self pointersTo.
	allReferences do: [:each | each isODBReference ifTrue: [^each odbTransaction]]."
	^nil
]

{ #category : #'*omnibase' }
Object class >> odbLoadVariables: deserializer classInfo: classInfo [

	| stream order iSize object basicSize varArray |
	stream := deserializer stream.
	classInfo isVariable
		ifTrue: [ object := self basicNew: (basicSize := stream getPositiveInteger) ]
		ifFalse: [
			basicSize := 0.
			object := self basicNew.
		].
	deserializer register: object.
	classInfo isBytes ifTrue: [
		classInfo realClass isWords 
			ifTrue: [1 to: basicSize do: [:i | object basicAt: i put: stream getInteger]]
			ifFalse: [stream getBytesFor: object len: basicSize].
		^object
	].
	varArray := Array new: (iSize := classInfo realInstSize) + 1.
	order := classInfo variableOrder.
	1 to: classInfo instSize do: [:i | varArray at: (order at: i) put: deserializer odbNextObject ].
	1 to: iSize do: [:i | object instVarAt: i put: (varArray at: i) ].
	iSize + 1 to: iSize + basicSize do: [:i | object instVarAt: i put: deserializer odbNextObject ].
	^object odbDeserialized: deserializer
]

{ #category : #'*omnibase' }
Object >> odbLoadedIn: anOmniBaseTransaction [
		"This method is sent when the object is loaded from the database."
]

{ #category : #'*omnibase' }
Object >> odbMadePersistentIn: anOmniBaseTransaction [
		"This method is sent when the object is made persistent."
]

{ #category : #'*omnibase' }
Object >> odbObject [
        "Answer real persistent object."

    ^self
]

{ #category : #'*omnibase' }
Object >> odbObjectID [

	^nil
]

{ #category : #'*omnibase' }
Object >> odbResolve [
	"If this were a proxy object it would resolve itself and answer a real persistent object from the database.
	Since this is not a proxy answer yourself.
	Note: This method is here because in Dolphin 5.1 sending yourself is optimized which means that there is no message
	send involved and a proxy does not fetch an object from the database, instead it answers itself a proxy."

	^self
]

{ #category : #'*omnibase' }
Object >> odbSerialize: serializer [ 
	(serializer register: self) ifTrue: [^self].
	self odbBasicSerialize: serializer
]

{ #category : #'*omnibase' }
Object >> odbToDo [
		"See implementors to list all methods in OmniBase which need to be improved."
]

{ #category : #'*omnibase' }
Object >> signalError: aString [
	self error: aString
]
