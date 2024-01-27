# Bookmind

Bookmind will remember your book collection and reading history. No signup. As little advertising as possible.

## Why might you be interested in Bookmind?

If you'd like to see my coding style, or how I break down and de-risk the task of implementing Bookmind, have a look at the source, prototypes and commit history. Always tackle the biggest risk first. 

## Current Version: Fetch Book Detail Prototype

We're currently wrapping up "stage two", fetching book details for scanned ISBNs. When the scan screen recognizes a result that may be an ISBN, we fetch book details from openlibrary. If the book is there we pull the title, authors and cover, and display them on the scan screen. We show an add button button but that won't work until we add persistence (probably stage three).

[Scan Screen](ScanScreen.jpeg)

"Stage one" evaluated the new-ish data scanner view controller. Scanning prototypes with earlier versions of vision found the bar code scanning pretty good, but text scanning complex and unreliable. Many books, particularly older ones, don't have a bar code. So the whole app wasn't going to fly without reliable text scanning.

## Installation

To run the app you will need
- Xcode 15 or later
- development team to sign the app
- iPhone with iOS 16 or later
	- the scanner does not work in simulator or on mac
	- the iPad ui looks awful, to be addressed in a future prototype
