public/unclassified
previousPage
        "Answer pointer to nextPage or <nil> if none."

    indexOnPage < 0 ifTrue: [^nil].
    ^self nextAt: indexOnPage