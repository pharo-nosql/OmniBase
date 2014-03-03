public
addExternalReference: anObject objectId: anObjectId 
	"Adds anObject as externaly referenced object.
	If this anObject is encountered during the serialization it will be replaced with an external reference to anObjectId and will not be serialized together."

	| dict |
	(dict := externalObjects at: anObject class) isNil 
		ifTrue: [dict := externalObjects at: anObject class put: anObject class odbGetRegDictionary].
	dict at: anObject put: anObjectId