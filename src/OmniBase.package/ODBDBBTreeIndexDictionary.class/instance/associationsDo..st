public
associationsDo: aBlock 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (Association key: association key
						value: (ODBValueHolder createOn: association value)).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]