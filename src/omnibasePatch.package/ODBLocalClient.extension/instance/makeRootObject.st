*omnibasePatch
makeRootObject
	"Private - Initialize root object."

	[:txn|
		txn
			root: ODBPersistentDictionary new;
			commit] value: self newTransaction