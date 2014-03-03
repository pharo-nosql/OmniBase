private/initialization
opened
                "Private - File has just been opened."

        | buffer bufSize |
        bufSize := ODBSizeHolder sizeInBytes + 2 + 2.
        buffer := ByteArray new: bufSize.
        stream getBytesFor: buffer.
        keyLength := buffer odbShortAt: bufSize - 3.
        valueLength := buffer odbShortAt: bufSize - 1.
        currentKey := ByteArray new: keyLength.
        nextKey := ByteArray new: keyLength