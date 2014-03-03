tests
testNumberOfClients

	| db |
	[
		db := OmniBase openOn: self dir.
		self assert: db numberOfClients equals: 0.
	] ensure: [db close].