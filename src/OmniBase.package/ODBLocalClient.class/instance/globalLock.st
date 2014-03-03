public/unclassified
globalLock
        "Set global write lock to all objects in the database.
        No other client will be able to write to the database
        until the lock is released by globalUnlock. Answer <true>
        if sucessfull or <false> if failed. Global lock will fail if
        any client (including local client) allready has read-write
        transactions running. When database is globaly locked only one
        read-write transaction can run at that time."

    | count |
    count := transactionFiles size.
    freeTransactionFile isNil ifFalse: [ count := count - 1 ].
    (hasGlobalLock not and: [ count == 0 ])
        ifTrue: [ hasGlobalLock := clientManager setGlobalLockFor: id ].
    ^hasGlobalLock