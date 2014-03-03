private/initialization
created
                "Private - File has just been created."

        | buffer bufSize |
        bufSize := ODBSizeHolder sizeInBytes + 4.
        buffer := ByteArray new: bufSize.
        buffer  
                odbShortAt: bufSize - 3 put: keyLength;
                odbShortAt: bufSize - 1 put: valueLength.
        stream putBytesFrom: buffer len: bufSize.
        (self pageClass createOnFile: self
                                        position: rootPagePosition
                                        keyLength: keyLength
                                        valueLength: valueLength) store.
        currentKey := ByteArray new: keyLength.
        nextKey := ByteArray new: keyLength.
        stream flush