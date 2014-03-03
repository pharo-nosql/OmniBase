public
referencesDo: aBlock 
	"A key is a persistent object and a value is a persistent object.
	Therefore we need to iterate over both."

	| valueHolder association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[(valueHolder := ODBValueHolder createOn: association value) isRemoved 
				ifFalse: 
					[aBlock value: (ODBObjectID new fromBytes: association key at: 1).
					aBlock value: valueHolder objectID].
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]