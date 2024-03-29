Class {
	#name : #ODBRootObjectDBHolder,
	#superclass : #ODBDatabaseObject,
	#category : #'OmniBase-Model'
}

{ #category : #defining }
ODBRootObjectDBHolder class >> classID [
        "Answer database object classID."

    ^1
]

{ #category : #public }
ODBRootObjectDBHolder >> makeTransactionObject: aTransaction [ 
	^ODBRootObjectHolder new 
		setObjectHolder: objectHolder
		dataBaseObject: objectHolder rootObjectID
		transaction: aTransaction
]

{ #category : #'public/transaction processing' }
ODBRootObjectDBHolder >> referencesDo: aBlock [

	aBlock value: objectHolder rootObjectID
]
