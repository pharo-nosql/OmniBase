create/open/close
openReadOnlyOn: aString

    stream := ODBFileStream openReadOnlyOn: aString.
    ^self compareHeader