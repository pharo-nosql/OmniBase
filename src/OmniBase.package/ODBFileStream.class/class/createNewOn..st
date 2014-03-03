create/open
createNewOn: pathName
        "Create new file on pathName. Trigger an error 
        if the file allready exists or if it can not be created."

    ^self createOn: pathName
        createMode: self createModeCreateNew
        accessMode: self accessModeReadWrite
        shareMode: self shareModeShareAll