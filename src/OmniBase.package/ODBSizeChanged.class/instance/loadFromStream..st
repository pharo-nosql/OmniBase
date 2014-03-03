public/load/store
loadFromStream: aStream

    objectID := ODBObjectID new loadFromStream: aStream.
    deltaSize := aStream getInteger