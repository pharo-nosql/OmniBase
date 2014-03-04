test
testExpiration

	| guy |

	guy := FLPersonMock testPerson.
	odb commit:[guy save].	
	
	odb commit:[
		guy := FLPersonMock first. 
		guy save.
		self assert: guy id isODBExpired not.
		self assert: guy id isODBReference.
		guy currentTransaction makePersistent: guy name. 
		guy currentTransaction markDirty: guy name].

	odb commit:[
		guy := FLPersonMock first]. 

	self assert: (guy id odbResolve class = ODBExpiredProxyObject).
	self assert: (guy name odbResolve class = ODBExpiredProxyObject).
