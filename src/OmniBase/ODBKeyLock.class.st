Class {
	#name : #ODBKeyLock,
	#superclass : #ODBLock,
	#instVars : [
		'key'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBKeyLock class >> lockClassID [
        "Answer unique class ID used for storing locks 
        or <nil> if lock does not need to be stored."

    ^2
]

{ #category : #'public/accessing' }
ODBKeyLock >> key [

    ^key
]

{ #category : #'public/accessing' }
ODBKeyLock >> key: aString [

    key := aString
]

{ #category : #'public/load/store' }
ODBKeyLock >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    lockID := aStream getLong.
    key := aStream getString asByteArray
]

{ #category : #'public/load/store' }
ODBKeyLock >> storeOnStream: aStream [

        objectID storeOnStream: aStream.
        aStream putLong: lockID.
        aStream putString: key
]

{ #category : #'public/unclassified' }
ODBKeyLock >> unlock [

    self transactionObject dataBaseObject unlockKey: key with: lockID
]
