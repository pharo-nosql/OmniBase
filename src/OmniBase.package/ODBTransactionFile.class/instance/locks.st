public/unclassified
locks
        "Answer all locks stored in transaction file."

    ^locks select: [:each | each notNil]