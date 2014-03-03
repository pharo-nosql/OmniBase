private
register: anObject 
	| class dict id |
	(dict := objects at: (class := anObject class)) isNil 
		ifTrue: 
			[(objects at: class put: class odbGetRegDictionary) at: anObject
				put: (counter := counter + 1).
			anObject == mainObject ifTrue: [^false].
			(dict := externalObjects at: class) isNil 
				ifFalse: 
					[(id := dict at: anObject) isNil 
						ifFalse: 
							[self saveExternalReference: id.
							^true]].
			^false].
	(id := dict at: anObject ifAbsentPutValue: counter + 1) > counter 
		ifTrue: 
			[counter := id.
			anObject == mainObject 
				ifFalse: 
					[(dict := externalObjects at: class) isNil 
						ifFalse: 
							[(id := dict at: anObject) isNil 
								ifFalse: 
									[self saveExternalReference: id.
									^true]]].
			^false].
	self saveInternalReference: id.
	^true