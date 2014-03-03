public
reopen
	idTable close.
	[idTable := ODBIDTable openOn: self idFileName] ifCurtailed: [environment close]