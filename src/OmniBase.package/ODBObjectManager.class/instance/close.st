create/open/close
close
        "Close object manager and all opened containers."

    | cnt |
    1 to: containers size do: [:i |
        (cnt := containers at: i) notNil ifTrue: [
            cnt close.
            containers at: i put: nil]].
    containers := OrderedCollection new.
    idTable isNil ifFalse: [idTable close].
    infoFile isNil ifFalse: [infoFile close]