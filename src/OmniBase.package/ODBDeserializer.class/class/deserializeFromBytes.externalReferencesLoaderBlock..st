public
deserializeFromBytes: aByteArray externalReferencesLoaderBlock: aBlock 
	| memoryStream referenceManager classManager |
	memoryStream := ODBMemoryReadStream new createOn: aByteArray.
	referenceManager := ODBReferenceManager new.
	referenceManager loadFromStream: memoryStream externalReferencesLoaderBlock: aBlock.
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom: memoryStream
		referenceManager: referenceManager
		classManager: classManager