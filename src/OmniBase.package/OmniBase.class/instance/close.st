public
close
	clientManager notNil 
		ifTrue: 
			[clientManager close.
			clientManager := nil].
	classManager notNil 
		ifTrue: 
			[classManager close.
			classManager := nil].
	objectManager notNil 
		ifTrue: 
			[objectManager close.
			objectManager := nil].
	transactionManager notNil 
		ifTrue: 
			[transactionManager close.
			transactionManager := nil].
	self class remove: self