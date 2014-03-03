public/transaction processing
commit

    transaction := transactionObject transaction.
    transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: deltaSize