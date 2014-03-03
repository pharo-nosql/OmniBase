accessing
transaction: aTransaction

    1 to: references size do: [:index |
        references at: index put: (aTransaction referenceAt: (references at: index))]