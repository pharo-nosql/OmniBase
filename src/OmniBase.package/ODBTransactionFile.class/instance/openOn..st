public/create/open/close
openOn: aString
        "Open transaction file. Signal an error if failed."

    stream := ODBFileStream createOn: aString
                            createMode: ODBFileStream createModeOpenExisting
                            accessMode: ODBFileStream accessModeReadWrite
                            shareMode: ODBFileStream shareModeShareRead
                            cacheMode: ODBFileStream cacheModeAtomicWrite.
    ^self compareHeader