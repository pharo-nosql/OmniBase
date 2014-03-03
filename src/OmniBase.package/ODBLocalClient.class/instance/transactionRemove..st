private/unclassified
transactionRemove: aTransaction
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil ifTrue: [ ^self ].
    freeTransactionFile == nil
        ifTrue: [ freeTransactionFile := trnFile reinitialize ]
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                ]
        ].
    transactionFiles size > 1 ifFalse: [ clientManager removeLocksFor: id ].
    transactions remove: aTransaction ifAbsent: []