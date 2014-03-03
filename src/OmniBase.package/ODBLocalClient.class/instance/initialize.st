private/initialization
initialize
        "Private - Initialize receiver."

    transactions := IdentitySet new: 20.
    transactionFiles := OrderedCollection new.
    hasGlobalLock := false.