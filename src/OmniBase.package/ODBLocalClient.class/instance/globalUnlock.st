public/unclassified
globalUnlock
        "Release global lock on database.
        Answer <true> if successfull."

    hasGlobalLock ifFalse: [ ^false ].
    transactions do: [:each | each isGlobalLocked ifTrue: [ ^false ]].
    clientManager globalUnlock.
    hasGlobalLock := false.
    ^true