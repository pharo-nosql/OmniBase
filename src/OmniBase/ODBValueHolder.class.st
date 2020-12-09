Class {
	#name : #ODBValueHolder,
	#superclass : #ODBExternalBuffer,
	#instVars : [
		'object',
		'removed',
		'objectSet'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBValueHolder class >> sizeInBytes [
	"versionNumber          4 bytes
	previousVersionPosition 4 bytes
	objectID                4 bytes
	-------------------------------
	total                   12 bytes"

	^12
]

{ #category : #'public/unclassified' }
ODBValueHolder >> getObjectIn: aTransaction [

	objectSet == true ifTrue: [^object].
	^aTransaction objectAt: self objectID
]

{ #category : #public }
ODBValueHolder >> isRemoved [
	"Answer <true> if the key has been removed 
	(there is no value associated with it)."

	removed isNil ifFalse: [^removed].
	^removed := (self uLongAtOffset: 8) = 0
]

{ #category : #public }
ODBValueHolder >> loadPreviousVersionFrom: oldHolders [ 
	| previousVersionPosition |
	previousVersionPosition := self previousVersionPosition.
	previousVersionPosition = 0 
		ifTrue: [contents := ByteArray new: contents size]
		ifFalse: [oldHolders loadAt: previousVersionPosition for: contents]
]

{ #category : #public }
ODBValueHolder >> makeNewVersion: oldHolders [ 
	"Store receiver to oldHolders and make new instance
	of receiver class that points to receiver in oldKeys."

	| position |
	self versionNumber = 0 
		ifTrue: [position := 0]
		ifFalse: [position := oldHolders store: contents].
	^(self class new)
		previousVersionPosition: position;
		updateOn: self
]

{ #category : #'public/unclassified' }
ODBValueHolder >> makeRemoved [
        "Mark valueHolder as removed."

    contents at: 8 put: ((contents at: 8) bitOr: 128)
]

{ #category : #'public/accessing' }
ODBValueHolder >> object [

    ^object
]

{ #category : #'public/accessing' }
ODBValueHolder >> object: anObject [

	object := anObject.
	removed := false.
	objectSet := true.
]

{ #category : #'public/accessing' }
ODBValueHolder >> objectID [

    ^ODBObjectID new fromBytes: contents at: 9
]

{ #category : #'public/accessing' }
ODBValueHolder >> objectID: anObjectID [

    anObjectID putBytesTo: contents at: 9
]

{ #category : #'private/accessing' }
ODBValueHolder >> previousVersionPosition [

    ^self uLongAtOffset: 4
]

{ #category : #'private/accessing' }
ODBValueHolder >> previousVersionPosition: anInteger [

    self uLongAtOffset: 4 put: anInteger
]

{ #category : #'public/unclassified' }
ODBValueHolder >> removed [
        "Key has been removed."

    object := nil.
    removed := true
]

{ #category : #public }
ODBValueHolder >> updateOn: aValueHolder [ 
	"Private - Make new version from aValueHolder."

	(removed := aValueHolder isRemoved) 
		ifFalse: 
			[object := aValueHolder object.
			objectSet := true]
]

{ #category : #'public/accessing' }
ODBValueHolder >> versionNumber [

    ^self uLongAtOffset: 0
]

{ #category : #'public/accessing' }
ODBValueHolder >> versionNumber: anInteger [

    self uLongAtOffset: 0 put: anInteger
]
