public
closeForeignClients
	"Close cached foreign clients."

	clients do: [:each | (each notNil and: [each isForeign]) ifTrue: [each remove]]