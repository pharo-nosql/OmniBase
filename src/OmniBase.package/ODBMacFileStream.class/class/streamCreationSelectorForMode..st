private
streamCreationSelectorForMode: createMode
	^ createMode caseOf:  {
		[self createModeCreateAlways] -> [#forceNewFileNamed:].
		[self createModeCreateNew] -> [#newFileNamed:].
		[self createModeOpenAlways] -> [#fileNamed:].
		[self createModeOpenExisting] -> [#oldFileNamed:]}
