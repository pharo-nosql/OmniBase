public/load/store
loadFromStream: aStream

    objectID := ODBObjectID new loadFromStream: aStream.
    lockID := aStream getLong