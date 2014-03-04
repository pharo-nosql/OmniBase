public
commit

	"Transcript cr; show: 'committing t: ', self hash asString,' p: ',Processor activeProcess hash asString."
	
	self
		checkpoint;
		abort