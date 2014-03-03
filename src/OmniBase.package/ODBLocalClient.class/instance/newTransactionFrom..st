public/unclassified
newTransactionFrom: aTransaction
        "Answer new transaction for receiver from aTransaction. 
        Objects accessible in aTransaction will also be accessible 
        in new transaction."

    | transaction |
    transaction := aTransaction class new.
    ^transaction setClient: self environment: clientManager environment; startFrom: aTransaction