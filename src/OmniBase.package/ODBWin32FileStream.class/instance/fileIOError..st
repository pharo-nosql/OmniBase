private
fileIOError: errorCode

	| description |
	description := '<no error description available>'.
	errorCode = 6 ifTrue: [description := 'Invalid handle'].
	errorCode = 183 ifTrue: [description := 'File already exists'].
	errorCode = 2 ifTrue: [description := 'File not found'].
	errorCode = 5 ifTrue: [description := 'Access denied'].
	errorCode = 80 ifTrue: [description := 'The file exists'].
	OmniBase signalError: 'File I/O error number ', errorCode printString, ' ', description