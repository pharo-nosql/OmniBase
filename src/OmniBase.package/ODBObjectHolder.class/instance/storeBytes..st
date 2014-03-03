load/store
storeBytes: aByteArray

    self objectLength: aByteArray size.
    container addByteStorageRequest: (ODBByteStorageRequest new
                                        objectHolder: self bytes: aByteArray)