private/unclassified
transactionAdd: aTransaction
        "Private - Add aTransaction to client."

    transactions add: aTransaction.
    aTransaction setClient: self environment: clientManager environment