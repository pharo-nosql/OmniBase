*omnibasepatch
odbGetTransaction
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