test
testExpirationTransformed

	| guy name |

	guy := FLPersonMock testPerson.
	name := guy name.
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
	
	odb readOnly:[
		self shouldnt:[guy name odbResolve first: 3] raise: Error.
		self shouldnt:[self assert: guy name asString = name] raise: Error].

