public
isAborted

	^ objectIndex isNil and:[
	objects isNil and:[
	client isNil and:[
	dbConnection isNil and:[
	transactionManager isNil and:[
	cacheMutex isNil]]]]]