public
valuesDo: aBlock 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (ODBValueHolder createOn: association value).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]