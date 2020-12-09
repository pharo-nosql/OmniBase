Class {
	#name : #ODBSizeHolder,
	#superclass : #ODBExternalBuffer,
	#category : 'OmniBase'
}

{ #category : #private }
ODBSizeHolder class >> sizeInBytes [

    ^12
]

{ #category : #'public/accessing' }
ODBSizeHolder >> dictionarySize [

    ^self uLongAtOffset: 0
]

{ #category : #'public/accessing' }
ODBSizeHolder >> dictionarySize: anInteger [

    self uLongAtOffset: 0 put: anInteger
]

{ #category : #'public/unclassified' }
ODBSizeHolder >> loadPreviousVersionFrom: oldHolders [

    oldHolders loadAt: self previousVersionPosition for: contents
]

{ #category : #'public/unclassified' }
ODBSizeHolder >> makeNewVersion: oldHolders [
        "Store receiver to oldHolders and make new instance 
        of receiver class that points to receiver in oldHolders."

    | newVersion position |
    self versionNumber = 0
        ifTrue: [ position := 0 ]
        ifFalse: [ position := oldHolders store: contents ].
    newVersion := self class new.
    ^newVersion previousVersionPosition: position
]

{ #category : #'private/accessing' }
ODBSizeHolder >> previousVersionPosition [

    ^self uLongAtOffset: 8
]

{ #category : #'private/accessing' }
ODBSizeHolder >> previousVersionPosition: anInteger [

    self uLongAtOffset: 8 put: anInteger
]

{ #category : #'public/accessing' }
ODBSizeHolder >> versionNumber [

    ^self uLongAtOffset: 4
]

{ #category : #'public/accessing' }
ODBSizeHolder >> versionNumber: anInteger [

    self uLongAtOffset: 4 put: anInteger
]
