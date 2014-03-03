public
databaseObjectClassID
	references isNil ifTrue: [^ODBSerializedDBObjectWithoutReferences classID].
	references size < 257 ifTrue: [^ODBSerializedDBObject256References classID].
	references size < 65537 ifTrue: [^ODBSerializedDBObject65536References classID]