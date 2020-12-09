Class {
	#name : #ODBTerminatedClient,
	#superclass : #ODBClient,
	#category : 'OmniBase'
}

{ #category : #'public/accessing' }
ODBTerminatedClient >> isTerminated [

    ^true
]

{ #category : #'private/unclassified' }
ODBTerminatedClient >> loadTransactions [

    | transactionFile transaction |
    clientFile transactionIDs do: [:fileID |
        [ transactionFile := ODBTransactionFile openOn: (self trnFileName: fileID) ]
            on: Error do: [:er | transactionFile := nil ].
        transactionFile notNil
            ifTrue: [
                transaction := ODBTerminatedTransaction new.
                transaction transactionFile: transactionFile.
                self transactionAdd: transaction.
                transaction start
            ]
    ]
]

{ #category : #'public/create/open/close' }
ODBTerminatedClient >> openOn: aClientManager clientID: clientID [

    | fName |
    id := clientID.
    clientManager := aClientManager.
    fName := clientManager clientFileName: id.
    [ clientFile := ODBClientFile new openOn: fName ]
        on: Error do: [:er | ^nil ].
    clientManager addOpenedClient: self.
    self loadTransactions
]
