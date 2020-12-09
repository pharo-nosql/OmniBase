Class {
	#name : #ODBObjectID,
	#superclass : #Object,
	#instVars : [
		'containerID',
		'index'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBObjectID class >> containerID: containerID index: index [

    ^super new containerID: containerID index: index
]

{ #category : #'as yet unclassified' }
ODBObjectID class >> new [

    ^super new containerID: 0 index: 0
]

{ #category : #private }
ODBObjectID class >> sizeInBytes [
	"Answer OID size in bytes.
	Note: If you change ODBObjectID>>sizeInBytes, then 
        you have to update ODBValueHolder>>sizeInBytes too."

	^4
]

{ #category : #public }
ODBObjectID >> = other [

    ^ self species = other species and: [
	other index == index and: [
	other containerID == containerID]]
]

{ #category : #'public/accessing' }
ODBObjectID >> containerID [

    ^containerID
]

{ #category : #'public/accessing' }
ODBObjectID >> containerID: byte index: ulong [

    containerID := byte.
    index := ulong
]

{ #category : #'public/accessing' }
ODBObjectID >> contents [
        "Answer ByteArray representing receiver."

    | bytes |
    bytes := ByteArray new: 4.
    bytes odbLongAt: 1 put: index; at: 4 put: containerID.
    ^bytes
]

{ #category : #'public/accessing' }
ODBObjectID >> contents: aByteArray [
        "Initialize receiver from aByteArray."

    containerID := aByteArray at: 4.
    index := ((aByteArray at: 3) bitShift: 16) + ((aByteArray at: 2) bitShift: 8) + (aByteArray at: 1)
]

{ #category : #'public/accessing' }
ODBObjectID >> fromBytes: aByteArray at: pos [
        "Initialize receiver from aByteArray at pos."

    containerID := aByteArray at: pos + 3.
    index := ((aByteArray at: pos + 2) bitShift: 16) +
                ((aByteArray at: pos + 1) bitShift: 8) +
                (aByteArray at: pos)
]

{ #category : #'public/unclassified' }
ODBObjectID >> hash [

    ^index + (containerID bitShift: 17)
]

{ #category : #'public/accessing' }
ODBObjectID >> index [

    ^index
]

{ #category : #'public/accessing' }
ODBObjectID >> index: ulong [

    index := ulong
]

{ #category : #'public/load/store' }
ODBObjectID >> loadFromStream: aStream [

    | bytes |
    bytes := ByteArray new: self class sizeInBytes.
    aStream getBytesFor: bytes.
    self fromBytes: bytes at: 1
]

{ #category : #public }
ODBObjectID >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPut: $(.
	containerID printOn: aStream.
	aStream nextPut: $:.
	index printOn: aStream.
	aStream nextPut: $)
]

{ #category : #'public/accessing' }
ODBObjectID >> putBytesTo: bytes at: pos [

	bytes
		odbLongAt: pos put: index;
		at: pos + 3 put: containerID
]

{ #category : #'public/load/store' }
ODBObjectID >> storeOnStream: aStream [

    aStream putBytesFrom: self contents
]
