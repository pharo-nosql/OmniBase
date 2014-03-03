instance creation
createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode
	"Private - Create new instance of file stream on pathName with given flags.
	This is Win32 API specific implementation."

	| crMode acMode shMode caMode |
	crMode := 0.
	createMode = #createModeCreateAlways ifTrue: [crMode := 2 "CREATE_ALWAYS"].
	createMode = #createModeCreateNew ifTrue: [crMode := 1 "CREATE_NEW"].
	createMode = #createModeOpenAlways ifTrue: [crMode := 4 "OPEN_ALWAYS"].
	createMode = #createModeOpenExisting ifTrue: [crMode := 3 "OPEN_EXISTING"].
	acMode := 0.
	accessMode = #accessModeReadOnly ifTrue: [acMode := 2147483648 "GENERIC_READ"].
	accessMode = #accessModeReadWrite ifTrue: [acMode := 3221225472 "GENERIC_READ | GENERIC_WRITE"].
	accessMode = #accessModeWriteOnly ifTrue: [acMode := 1073741824 "GENERIC_WRITE"].
	shMode := 0.
	shareMode = #shareModeShareAll ifTrue: [shMode := 3 "FILE_SHARE_READ | FILE_SHARE_WRITE"].
	shareMode = #shareModeShareNone ifTrue: [shMode := 0].
	shareMode = #shareModeShareRead ifTrue: [shMode := 1 "FILE_SHARE_READ"].
	shareMode = #shareModeShareWrite ifTrue: [shMode := 2 "FILE_SHARE_WRITE"].
	caMode := 0.
	cacheMode = #cacheModeAtomicWrite ifTrue: [caMode := 512  "FILE_FLAG_ATOMIC_WRITE"].
	cacheMode = #cacheModeSequentialScan ifTrue: [caMode := 134217728 "FILE_FLAG_SEQUENTIAL_SCAN"].
	^self new createOn: pathName createMode: crMode accessMode: acMode shareMode: shMode cacheMode: caMode
