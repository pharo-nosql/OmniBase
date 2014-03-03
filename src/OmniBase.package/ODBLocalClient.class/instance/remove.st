public/unclassified
remove

    freeTransactionFile isNil ifFalse: [ freeTransactionFile remove ].
    freeTransactionFile := true. "do not cache transaction files anymore"
    ^super remove