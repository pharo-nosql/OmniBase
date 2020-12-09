Class {
	#name : #ODBObjectStorage,
	#superclass : #ODBFile,
	#category : 'OmniBase'
}

{ #category : #'private/initialization' }
ODBObjectStorage >> descriptionString [

    ^'OmniBase Object Storage
OmniBase 1.0, David Gorisek (c) 1998

'
]

{ #category : #public }
ODBObjectStorage >> isEmpty [
	^stream size == self headerLength
]

{ #category : #'public/unclassified' }
ODBObjectStorage >> removeAll [

	stream truncate: self headerLength
]
