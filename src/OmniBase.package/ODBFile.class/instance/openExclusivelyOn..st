create/open/close
openExclusivelyOn: aString

	stream := ODBFileStream openExclusivelyOn: aString.
	^self compareHeader