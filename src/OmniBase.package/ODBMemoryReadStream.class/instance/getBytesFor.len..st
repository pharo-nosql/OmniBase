public
getBytesFor: aByteCollection len: len

    aByteCollection
        replaceFrom: 1
        to: len
        with: current
        startingAt: position + 1.
    position := position + len