public/create/open/close
close

    idTable isNil ifFalse: [idTable close].
    infoFile isNil ifFalse: [infoFile close]