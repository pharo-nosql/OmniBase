public
createOn: aString 
	"Create garbage collector file. Answer <nil> if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateNew
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead.
	^self writeHeader