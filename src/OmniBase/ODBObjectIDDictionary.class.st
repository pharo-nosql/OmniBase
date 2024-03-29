Class {
	#name : #ODBObjectIDDictionary,
	#superclass : #Object,
	#instVars : [
		'dictionaries'
	],
	#category : #'OmniBase-Model'
}

{ #category : #public }
ODBObjectIDDictionary >> at: objectID [ 
	"Answer transaction object at objectID or <nil> if absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil ifTrue: [^nil].
	^dict at: objectID index
]

{ #category : #public }
ODBObjectIDDictionary >> at: objectID ifAbsentPut: anObject [ 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := ODBIdentityDictionary new)].
	^dict at: objectID index ifAbsentPut: anObject
]

{ #category : #public }
ODBObjectIDDictionary >> at: objectID put: anObject [ 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := ODBIdentityDictionary new)].
	^dict at: objectID index put: anObject
]

{ #category : #initialization }
ODBObjectIDDictionary >> initialize [

    dictionaries := Array new: 255
]

{ #category : #public }
ODBObjectIDDictionary >> removeKey: objectID [ 
	"Remove transaction object association with objectID. 
	Do nothing if objectID is absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifFalse: [dict removeKey: objectID index]
]
