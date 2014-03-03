public/load/store
loadFromStream: aStream

    objectID := ODBObjectID new loadFromStream: aStream.
    oldVersion := ODBObjectHolder new loadFromStream: aStream.
    newVersion := ODBObjectHolder new loadFromStream: aStream.