private
saveInternalReference: anInteger
		"Shrani referenco na interni objekt z indeksom anInteger."

	stream putByte: 4; putPositiveInteger: anInteger