private
createFileStreamForPath: pathString createMode: createMode
	^ FileStream concreteStream
			perform: (self streamCreationSelectorForMode: createMode)
			with: pathString