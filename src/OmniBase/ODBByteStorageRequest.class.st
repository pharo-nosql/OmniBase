Class {
	#name : #ODBByteStorageRequest,
	#superclass : #Object,
	#instVars : [
		'objectHolder',
		'byteArray'
	],
	#category : 'OmniBase'
}

{ #category : #'public/accessing' }
ODBByteStorageRequest >> bytes [

    ^byteArray
]

{ #category : #'public/unclassified' }
ODBByteStorageRequest >> bytesStored [
]

{ #category : #'public/accessing' }
ODBByteStorageRequest >> objectHolder [

    ^objectHolder
]

{ #category : #'public/accessing' }
ODBByteStorageRequest >> objectHolder: anObjectHolder bytes: aByteArray [

    objectHolder := anObjectHolder.
    byteArray := aByteArray
]

{ #category : #'public/accessing' }
ODBByteStorageRequest >> objectPosition: anInteger [

    objectHolder objectPosition: anInteger
]
