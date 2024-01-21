# Bookmind

Bookmind will remember your book collection and reading history. No signup. As little advertising as possible.

## Fetch Book Detail Prototype

The second version adds book detail lookup. As the user scans possible ISBNs the app will request details in the background. If details for the scanned ISBN are available on openlibrary, the app will display the book title. Stage 2b fetches authors. Stage 2c will fetch cover art, then on to persistence.

## ISBN Bar Code Scan Prototype

The initial version is an evaluation of the new-ish data scanner view controller. Scanning prototypes with earlier versions of vision found the bar code scanning pretty good, but text scanning complex and unreliable. Uncommitted tests indicate text scanning is significantly improved! The next prototype version will likely be an ISBN text scan (for those much older books without bar codes).

## Why might you be interested in Bookmind?

If you'd like to see my coding style, or how I break down and de-risk the task of implementing Bookmind, have a look at the source, prototypes and commit history. Always tackle the biggest risk first. 

## Installation

To run the app you will need
- Xcode 15 or later
- development team to sign the app
- iPhone with iOS 16 or later
	- the scanner does not work in simulator or on mac
	- the iPad ui looks awful, to be addressed in a future prototype
