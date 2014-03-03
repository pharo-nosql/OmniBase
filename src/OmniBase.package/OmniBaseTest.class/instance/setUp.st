running
setUp
	| db |
	[db := OmniBase createOn: self dir ] ensure: [db close]