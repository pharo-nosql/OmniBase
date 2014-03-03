public
compareHeader
	"Private - Compare bytes in file with file header. Answer <nil>, 
	if the file does not have the appropriate description string."

	| header |
	header := self header.
	
	[(stream compare: (header copyFrom: 2 to: header size) at: 1) 
		ifFalse: [OmniBase signalError: 'File has bad header'].
	self opened] 
			ifCurtailed: [self close]