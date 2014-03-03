private/initialization
created
                "Private - File has just been created."

        stream putWord: 0.
        (self pageClass createOnFile: self
                                        position: rootPagePosition
                                        keyLength: keyLength
                                        valueLength: valueLength) store.
        currentKey := ByteArray new: keyLength.
        stream flush