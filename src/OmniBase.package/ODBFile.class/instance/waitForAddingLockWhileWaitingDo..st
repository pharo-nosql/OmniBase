locking
waitForAddingLockWhileWaitingDo: aBlock
        "Lock file for writing at the end of the file."

    ^self waitForLockAt: 0 length: 1 whileWaitingDo: aBlock