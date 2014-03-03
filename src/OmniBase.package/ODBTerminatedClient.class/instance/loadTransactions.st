private/unclassified
loadTransactions

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