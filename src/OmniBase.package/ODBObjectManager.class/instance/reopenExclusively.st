public
reopenExclusively
	| result |
	result := false.
	idTable close.
	
	[idTable := ODBIDTable new openExclusivelyOn: self idFileName.
	result := true] on: Error
			do: [:ex | [idTable := ODBIDTable openOn: self idFileName] ifCurtailed: [environment close]].
	^result