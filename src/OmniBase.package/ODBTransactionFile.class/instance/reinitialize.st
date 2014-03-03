public/create/open/close
reinitialize
        "Reinitialize an opened transaction file."

    | bytes |
    newLockPosition := self headerLength + 10.
    bytes := ByteArray new: 11.
    bytes odbShortAt: 9 put: transactionID.
    stream position: newLockPosition - 10; putBytesFrom: bytes.
    recovery := nil.
    self initialize