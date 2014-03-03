private
addLoggedLock: aLock 
	"Private - Add aLock to receiver and store it to transaction file."

	locks add: aLock.
	transactionFile lockAdd: aLock