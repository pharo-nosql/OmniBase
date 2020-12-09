Class {
	#name : #ODBDemandLoader,
	#superclass : #Object,
	#instVars : [
		'objectID',
		'transaction',
		'proxyObject'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBDemandLoader >> getObject [
	^proxyObject odbSetTransactionObject: (transaction transactionObjectAt: objectID)
]

{ #category : #'public/accessing' }
ODBDemandLoader >> odbObjectID [

    ^objectID
]

{ #category : #public }
ODBDemandLoader >> odbSerialize: serializer [ 
	(serializer register: objectID) ifFalse: [^serializer saveExternalReference: objectID]
]

{ #category : #'private/intercepted messages' }
ODBDemandLoader >> perform: selector withArguments: arguments [

    ^self getObject
        perform: selector
        withArguments: arguments
]

{ #category : #'private/accessing' }
ODBDemandLoader >> printOn: aStream [

    objectID printOn: aStream.
    ^proxyObject
]

{ #category : #'public/accessing' }
ODBDemandLoader >> setTransaction: aTransaction objectID: anObjectID proxyObject: anODBReference [

    transaction := aTransaction.
    objectID := anObjectID.
    proxyObject := anODBReference
]

{ #category : #'public/accessing' }
ODBDemandLoader >> transaction [

    ^transaction
]
