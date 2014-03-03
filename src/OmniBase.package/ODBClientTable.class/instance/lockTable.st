private
lockTable
                "Private - Lock client table from being changed."

	self waitForLockAt: self headerLength length: table size