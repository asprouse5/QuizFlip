# QuizFlip
Social trivia game

A social trivia game designed to challenge your family and friends!

To compile this project you will need a `Constants.swift` file in the `Other` folder. Here is an example:

    struct Constants {
        static let versionURL = "https://path/to/version.txt"
        static let starterURL = "https://path/to/starter.json"
        static let allURLs = ["https://path/to/category1.txt",
                              "https://path/to/category2.txt"]

        static let endQA = "Message to display at end of categories"
        static var multiplier = 4 // number of categories + 1
    }

This project is a learning experience for me as I learn the best practices of Swift.
