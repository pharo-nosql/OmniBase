Class {
	#name : #ODBObjectLock,
	#superclass : #ODBLock,
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBObjectLock class >> lockClassID [
        "Answer unique class ID used for storing locks 
        or <nil> if lock does not need to be stored."

    ^1
]

{ #category : #'public/load/store' }
ODBObjectLock >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    lockID := aStream getLong
]

{ #category : #'public/load/store' }
ODBObjectLock >> storeOnStream: aStream [

        objectID storeOnStream: aStream.
        aStream putLong: lockID
]

{ #category : #'public/unclassified' }
ODBObjectLock >> unlock [

    ^(transaction objectHolderAt: objectID) unlockWith: lockID
]
