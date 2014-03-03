public/unclassified
transactionID: anInteger

    transactionID := anInteger.
    stream position: self headerLength + 8; putWord: anInteger