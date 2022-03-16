Class {
	#name : #ODBDictionaryChanged,
	#superclass : #ODBChange,
	#instVars : [
		'dataBaseObject'
	],
	#category : #'OmniBase-Events'
}

{ #category : #'transaction processing' }
ODBDictionaryChanged >> committed [

	"Changes have been committed, update transaction object."

	dataBaseObject ifNotNil: [ transactionObject setDataBaseObject: dataBaseObject ].
	transactionObject objectCommitted
]

{ #category : #'public/accessing' }
ODBDictionaryChanged >> dataBaseObject: anObject [

    dataBaseObject := anObject
]
