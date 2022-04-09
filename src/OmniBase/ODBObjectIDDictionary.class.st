Class {
	#name : #ODBObjectIDDictionary,
	#superclass : #Object,
	#instVars : [
		'dictionaries'
	],
	#category : #'OmniBase-Model'
}

{ #category : #accessing }
ODBObjectIDDictionary >> at: objectID [

	"Answer transaction object at objectID or <nil> if absent."

	^ (dictionaries at: objectID containerID) ifNotNil: [ :dict | 
		  dict at: objectID index ]
]

{ #category : #public }
ODBObjectIDDictionary >> at: objectID ifAbsentPut: anObject [

	| dict |
	(dict := dictionaries at: objectID containerID) ifNil: [ 
		dictionaries
			at: objectID containerID
			put: (dict := ODBIdentityDictionary new) ].
	^ dict at: objectID index ifAbsentPut: anObject
]

{ #category : #accessing }
ODBObjectIDDictionary >> at: objectID put: anObject [

	| dict |
	(dict := dictionaries at: objectID containerID) ifNil: [ 
		dictionaries
			at: objectID containerID
			put: (dict := ODBIdentityDictionary new) ].
	^ dict at: objectID index put: anObject
]

{ #category : #initialization }
ODBObjectIDDictionary >> initialize [

    dictionaries := Array new: 255
]

{ #category : #public }
ODBObjectIDDictionary >> removeKey: objectID [

	"Remove transaction object association with objectID. 
	Do nothing if objectID is absent."

	(dictionaries at: objectID containerID) ifNotNil: [ :dict | 
		dict removeKey: objectID index ]
]
