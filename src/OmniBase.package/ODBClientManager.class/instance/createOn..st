public/create/open/close
createOn: anEnvironment
        "Create new user manager."

    environment := anEnvironment.
    [   idTable := ODBClientTable createOn: self idFileName.
        self opened
    ] ifCurtailed: [ self close ]