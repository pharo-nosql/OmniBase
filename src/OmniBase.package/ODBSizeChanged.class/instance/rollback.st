public/transaction processing
rollback

    self transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: 0 - deltaSize