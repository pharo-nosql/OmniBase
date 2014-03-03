public
remove
	iterator isNil 
		ifFalse: 
			[objectHolder container removeObjectFile: objectHolder fileID.
			iterator := nil]