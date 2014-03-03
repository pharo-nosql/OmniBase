private
basicGoTo: aByteArray 
	currentKey := aByteArray.
	changed isNil ifFalse: [changed goTo: currentKey]