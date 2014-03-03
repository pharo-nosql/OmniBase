public/load/store
storeOnStream: aStream

    objectID storeOnStream: aStream.
    aStream putString: key.
    oldValue storeOnStream: aStream.
    newValue storeOnStream: aStream