private
keyFromBytes: aByteArray 
	transaction referenceAt: (ODBObjectID new fromBytes: aByteArray at: 1)