public/create/open/close
createOn: aString
        "Create client file. Signal an error if failed."

    stream := ODBFileStream createOn: aString
                            createMode: ODBFileStream createModeCreateNew
                            accessMode: ODBFileStream accessModeReadWrite
                            shareMode: ODBFileStream shareModeShareRead.
    ^self writeHeader