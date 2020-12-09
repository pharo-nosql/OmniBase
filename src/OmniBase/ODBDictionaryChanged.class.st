Class {
	#name : #ODBDictionaryChanged,
	#superclass : #ODBChange,
	#instVars : [
		'dataBaseObject'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBDictionaryChanged >> committed [
	"Changes have been committed, update transaction object."

	dataBaseObject isNil ifFalse: [transactionObject setDataBaseObject: dataBaseObject].
	transactionObject objectCommitted
]

{ #category : #'public/accessing' }
ODBDictionaryChanged >> dataBaseObject: anObject [

    dataBaseObject := anObject
]
