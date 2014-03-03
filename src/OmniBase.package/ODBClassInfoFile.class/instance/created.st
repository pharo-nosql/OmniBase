private/initialization
created
                "Private - File has just been created."

        (self pageClass createOnFile: self
                                        position: rootPagePosition
                                        keyLength: keyLength
                                        valueLength: valueLength) store.
        currentKey := ByteArray new: keyLength.
        stream flush