public/iterator
getLast

    currentIndex := elementCount.
    ^ODBBTreeDictionaryAssociation new
        setKey: (keys at: currentIndex) value: (values at: currentIndex)