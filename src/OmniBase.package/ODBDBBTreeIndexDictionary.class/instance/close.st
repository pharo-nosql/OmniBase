public
close
	iterator notNil 
		ifTrue: 
			[objectHolder container closeObjectFile: objectHolder fileID.
			iterator := nil]