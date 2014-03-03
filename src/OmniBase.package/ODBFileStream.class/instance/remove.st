public
remove
        "Close and remove receiver. Answer <true> if removed."

    self close.
    ^self class remove: pathName