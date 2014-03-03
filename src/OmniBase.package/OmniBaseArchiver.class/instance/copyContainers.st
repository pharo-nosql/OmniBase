private
copyContainers
	| container i |
	i := 1.
	
	[container := db objectManager containerAt: i ifAbsent: [].
	i := i + 1.
	container isNil] 
			whileFalse: [self copyContainer: container]