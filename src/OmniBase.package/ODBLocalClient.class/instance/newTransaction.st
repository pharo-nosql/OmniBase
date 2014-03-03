public/unclassified
newTransaction
        "Answer new transaction for receiver."

    | transaction |
    hasGlobalLock
        ifFalse: [ transaction := ODBLocalTransaction new ]
        ifTrue: [ transaction := ODBGlobalLockedTransaction new ].
    ^transaction setClient: self environment: clientManager environment; start