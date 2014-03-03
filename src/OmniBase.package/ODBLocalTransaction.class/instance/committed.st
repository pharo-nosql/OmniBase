private
committed
        "Private - Transaction has just been committed."

    "End of transaction"
    transactionFile recovery: nil.
    transactionManager transactionCommitEnd: self.
    "Update transaction objects"        
    changesPackage committed.
    changesPackage := nil.