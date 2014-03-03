*omnibase
odbSerialize: serializer 
	(serializer register: self) ifTrue: [^self].
	self odbBasicSerialize: serializer