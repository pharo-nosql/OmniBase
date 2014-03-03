public
at: aKey put: anObject ifLocked: aBlock 
	"Associate aKey with anObject.
	Evaluate aBlock if aKey has been locked before in some other transaction."

	| oid |
	^transaction isNil 
		ifTrue: [newKeys at: aKey odbResolve put: anObject]
		ifFalse: 
			[(oid := transaction getObjectIDOrNil: aKey) isNil 
				ifTrue: [newKeys at: aKey put: anObject]
				ifFalse: 
					[super 
						at: oid
						put: anObject
						ifLocked: aBlock]]