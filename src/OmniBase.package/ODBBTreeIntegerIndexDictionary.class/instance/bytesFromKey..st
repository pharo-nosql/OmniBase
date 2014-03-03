private
bytesFromKey: anInteger 
	^((ByteArray new: 4) odbLongAt: 1 put: anInteger) reverse