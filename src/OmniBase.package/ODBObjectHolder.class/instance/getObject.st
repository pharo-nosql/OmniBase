load/store
getObject
        "Answer database object."

    ^(ODBDatabaseObject persistentClassAt: self persistentClassID) new openOn: self