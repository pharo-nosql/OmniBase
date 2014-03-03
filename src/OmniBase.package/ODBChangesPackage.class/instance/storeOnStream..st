public
storeOnStream: aStream 
	"Store receiver on aStream."

	| memoryStream classID |
	memoryStream := ODBMemoryWriteStream new.
	changes do: 
			[:each | 
			(classID := each class changeClassID) isNil 
				ifFalse: 
					[memoryStream putByte: classID.
					each storeOnStream: memoryStream]].
	memoryStream
		putByte: 0;
		writeOn: aStream