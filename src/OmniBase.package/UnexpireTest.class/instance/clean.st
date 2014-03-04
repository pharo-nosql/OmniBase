actions
clean

	odb commit:[
		self aggregates do:[:e| e destroy]]