public/create/open/close
createOn: aString

    stream := ODBFileStream createOn: aString
                            createMode: ODBFileStream createModeCreateAlways
                            accessMode: ODBFileStream accessModeReadWrite
                            shareMode: ODBFileStream shareModeShareAll
                            cacheMode: ODBFileStream cacheModeAtomicWrite.
    ^self writeHeader