*omnibasePatch
getObjectIDOrNil: anObject 
	"Private - Answer <objectID> coresponding to anObject 
        or <nil> if not allready stored."

	| transactionObject oid |
	anObject odbObjectID isNil ifFalse: [^anObject odbObjectID].

	self isAborted ifTrue:[^nil].

	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	^transactionObject isNil 
		ifFalse: [(oid := transactionObject objectID) index == 0 ifFalse: [oid]]