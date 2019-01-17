# Fruity Groups
**An AppleScript GUI to help with GnuPG Groups**

GnuPG has a "groups" functionality, but I am unaware of a GUI to interact with
it. This AppleScript prompts the user to select one for more lists of recipients
in the form of text files, then one or more files to be encrypted. It will
encrypt each file to all of the selected recipients.

Text files representing "groups" should have one 'name' per line. This can be
any valid identifier that can be passed as "gpg -er `name`" (eg. an email
address, keyid or fingerprint ). Text files should end with the `.txt`
extension.

A selected file to encrypt, `file.ext`, will be encrypted as `file.ext.gpg`. If
a file with the destination name already exists, the user will be prompted to
skip or overwrite the file or cancel encrypting all remaining files.

## Installation
1. Clone this repo
2. Run the `bin/build.sh`
3. Copy the `build/encrypt-to-list.app` file to `/Applications`

## Usage
1. Run the applet
2. Select one or more recipient groups
3. Select one or more files to encrypt

## See
- https://www.gnupg.org/
- https://gpgtools.org/
