# StarIsTypeBot

`StarIsTypeBot` is a GitHub bot that crawls Haskell repositories and creates pull requests that change `*` to `Type` from `Data.Kind`.

## Installation

1. Clone this repository:

`git clone https://github.com/charles37/StarIsTypeBot.git`

2. Install the dependencies:

`stack install`


3. Create a personal access token on GitHub that has permission to read and write to repositories.

4. Copy the token to a file called `token.txt` in the root of the repository.

## Usage

To run the bot, simply execute the `StarIsTypeBot` binary:

`stack exec StarIsTypeBot`


The bot will authenticate with GitHub using the personal access token in `token.txt`, search for Haskell repositories, clone each repository to a local directory, replace all occurrences of `*` with `Type` from `Data.Kind` in each `.hs` file, make a Git commit with the changes, push the commit to GitHub as a new branch, and create a pull request from the new branch to the original repository.

The bot will process up to 10 repositories by default, but you can change this by editing the `processRepo` function in `Main.hs`.

## Contributing

Contributions are welcome! If you find a bug or have an idea for a new feature, please open an issue or submit a pull request.

## License

`StarIsTypeBot` is licensed under the GPLv3 License. See `LICENSE` for details.
