public/start/commit/abort
start
        "Start transaction. Transaction has been terminated 
        without being aborted in previous session."

    transactionManager transactionStart: self.
    versionDescriptor versionNumber: transactionFile versionNumber.
    locks := transactionFile locks