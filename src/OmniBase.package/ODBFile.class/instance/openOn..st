create/open/close
openOn: aString

    stream := ODBFileStream openOn: aString.
    ^self compareHeader