Class {
	#name : #ODBAssociationChanged,
	#superclass : #ODBChange,
	#instVars : [
		'key',
		'oldValue',
		'newValue'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBAssociationChanged class >> changeClassID [
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^2
]

{ #category : #'public/transaction processing' }
ODBAssociationChanged >> commit [

    transactionObject dataBaseObject at: key put: newValue
]

{ #category : #'public/accessing' }
ODBAssociationChanged >> key: aString [

    key := aString
]

{ #category : #'public/load/store' }
ODBAssociationChanged >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    key := aStream getString asByteArray.
    oldValue := ODBValueHolder new loadFromStream: aStream.
    newValue := ODBValueHolder new loadFromStream: aStream
]

{ #category : #'public/accessing' }
ODBAssociationChanged >> newValue: aValue [

    newValue := aValue
]

{ #category : #'public/accessing' }
ODBAssociationChanged >> oldValue: aValue [

    oldValue := aValue
]

{ #category : #'public/transaction processing' }
ODBAssociationChanged >> rollback [

    self transactionObject dataBaseObject at: key put: oldValue
]

{ #category : #'public/load/store' }
ODBAssociationChanged >> storeOnStream: aStream [

    objectID storeOnStream: aStream.
    aStream putString: key.
    oldValue storeOnStream: aStream.
    newValue storeOnStream: aStream
]
