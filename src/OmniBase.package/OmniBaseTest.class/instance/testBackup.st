tests
testBackup
	"Test database backup."

	| db t obj |
	db := OmniBase openOn: self dir.
	t := db newTransaction.
	obj := Array with: 'to je test'.
	t makePersistent: obj.
	t root at: 'backup1' put: obj.
	obj := OmniBase newBTreeDictionary: 20.
	t makePersistent: obj.
	obj at: 'test' put: 'test'.
	t root at: 'backup2' put: obj.
	t commit.
	db createBackupOn: self dir, 'BackupTest'.
	db close.
	db := OmniBase openOn: self dir, 'BackupTest'.
	t := db newTransaction.
	
	self assert: (t root at: 'backup1') = (Array with: 'to je test').
	self assert: ((t root at: 'backup2') at: 'test') = 'test'.
	
	db close.
	(self dir, 'BackupTest') asFileReference ensureDeleteAll