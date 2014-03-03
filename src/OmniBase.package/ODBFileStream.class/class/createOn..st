create/open
createOn: pathName
        "Create new file on pathName. Trigger an 
        exception if the file can not be created."

    ^self createOn: pathName
        createMode: self createModeCreateAlways
        accessMode: self accessModeReadWrite
        shareMode: self shareModeShareAll