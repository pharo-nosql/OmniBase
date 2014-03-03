public/unclassified
newTransactionInVersion: aVersionDescriptor
        "Answer new transaction with given version descriptor."

    | transaction |
    hasGlobalLock
        ifFalse: [ transaction := ODBLocalTransaction new ]
        ifTrue: [ transaction := ODBGlobalLockedTransaction new ].
    ^transaction setClient: self environment: clientManager environment; startInVersion: aVersionDescriptor