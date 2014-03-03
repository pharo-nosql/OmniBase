public/create/open/close
openOn: anOmniBase

	environment := anOmniBase.
	[	idTable := ODBClientTable openOn: self idFileName.
		self opened
	] ifCurtailed: [ self close ]