public/load/store
storeOnStream: aStream

        objectID storeOnStream: aStream.
        aStream putLong: lockID.
        aStream putString: key