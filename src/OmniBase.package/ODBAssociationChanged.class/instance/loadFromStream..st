public/load/store
loadFromStream: aStream

    objectID := ODBObjectID new loadFromStream: aStream.
    key := aStream getString asByteArray.
    oldValue := ODBValueHolder new loadFromStream: aStream.
    newValue := ODBValueHolder new loadFromStream: aStream