public
containerNamed: containerName
        "Answer container with containerName or 
        default container, if container is not found."

    ^self containerNamed: containerName ifAbsent: [^self defaultContainer]