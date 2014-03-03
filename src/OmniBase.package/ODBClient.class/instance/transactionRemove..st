private/unclassified
transactionRemove: aTransaction
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                    transactionFiles isEmpty
                        ifTrue: [ clientManager removeLocksFor: id ]
                ]
        ].
    transactions remove: aTransaction ifAbsent: []