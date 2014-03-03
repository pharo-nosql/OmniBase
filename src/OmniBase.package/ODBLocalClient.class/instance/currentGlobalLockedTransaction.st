private/for transaction control only
currentGlobalLockedTransaction

    transactions do: [:each | each transactionFile == nil ifFalse: [ ^each ]].
    ^nil