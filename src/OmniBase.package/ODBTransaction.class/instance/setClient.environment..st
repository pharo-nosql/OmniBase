private
setClient: aClient environment: anOmniBase 
	client := aClient.
	dbConnection := anOmniBase.
	transactionManager := dbConnection transactionManager