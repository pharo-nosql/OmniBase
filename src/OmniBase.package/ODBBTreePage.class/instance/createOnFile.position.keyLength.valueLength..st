private/initialization
createOnFile: anODBTreeIterator
    position: position
    keyLength: keyLen
    valueLength: valueLen
        "Private - Create receiver on file."

    iterator := anODBTreeIterator.
    keyLength := keyLen.
    valueLength := valueLen.
    itemLength := keyLength + valueLength + 2. "key+value+lockID"
    pagePosition := position.
    indexOnPage := 0.
    contents := ByteArray new: self bytesPerPage