create/open/close
createOn: aString

    stream := ODBFileStream createOn: aString.
    ^self writeHeader