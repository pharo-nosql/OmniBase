public/create/open/close
close

    clients isNil
        ifFalse: [
            clients do: [:each | each == nil ifFalse: [ each remove ]].
            clients := nil ].
    idTable isNil
        ifFalse: [
            idTable close.
            idTable := nil ]