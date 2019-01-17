----------------------------------------------
-- Fruity Groups
-- An AppleScript GUI to help with GnuPG Groups
--
-- Select group(s) of keys to encrypt to
-- Select file(s) to encrypt
-- Encrypts each file as file.gpg
-- If naming conflict, prompts to overwrite
----------------------------------------------

-- Configuration
global gpgPath, gpgArgs, cleanSed

-- path to gpg
set gpgPath to "/usr/local/bin/gpg"

-- gpg args
set gpgArgs to " --trust-model always --no-auto-key-locate -e "

-- sed to strip comments and whitespace
set cleanSed to "sed -E 's/#.*//; s/^[[:space:]]+//; s/[[:space:]]+$//; /^$/d' "



--
-- Does a file exist?
--
-- @param string theFile path to a file
--
-- @return bool
--
on fileExists(aFile)
    tell application "System Events"
        if exists file aFile then
            return true
        else
            return false
        end if
    end tell
end fileExists

--
-- Read a file as a list of lines removing comments and spaces
--
-- @param alias aFile finder alias of a file
--
-- @return {list}
--
on readLines(aFile)
    return paragraphs of (do shell script cleanSed & (POSIX path of aFile))
end readLines

--
-- Get recipients from files
--
-- @param list groups finder file aliases
--
-- @return {list}
--
on readGroups(groups)
    set rcpts to {}
    repeat with group in groups
        set rcpts to rcpts & readLines(group)
    end repeat
    return rcpts
end readGroups

--
-- Convert list of recipients to flags for gpg
--
-- trims entries and removes blanks
--
-- @param list theRecipients list of recipients
--
-- @return string
--
on buildRecipientArgs(rcpts)
    set args to ""
    repeat with rcpt in rcpts
        if length of rcpt > 0 then
            set args to "-r \"" & rcpt & "\" " & args
        end if
    end repeat
    return args
end buildRecipientArgs

--
-- Encrypt a file to recipients
--
-- TODO: Configurable gpg option flags
--
-- @param string  src   quoted src path
-- @param string  dest  destination path
-- @param string  rcpts recipient arg string
--
-- @return void
--
on encryptFileTo(src, dest, rcpts)
    set gpgCmd to gpgPath & gpgArgs & rcpts & " -o " & (quoted form of dest) & " " & src
    do shell script (gpgCmd)
end encryptFileTo

--
-- If file exists, should we overwrite?
--
-- @return bool
--
on confirmEncrypt(dest)
    if fileExists(dest) then
        set msg to "File already exists: " & dest
        set btns to {"Skip", "Overwrite", "Cancel"}
        display dialog msg with icon stop buttons btns default button 1
        if button returned of result = "Overwrite" then
            do shell script "rm " & quoted form of dest
        else
            return false
        end if
    end if
    return true
end confirmEncrypt

--
-- Encrypt file(s) to recipient(s)
--
-- @return void
--
on fruityGroups()
    set groups to choose file with prompt "Select recipient list(s):" of type {"txt"} with multiple selections allowed
    set sFiles to choose file with prompt "Select file(s) to encrypt:" with multiple selections allowed

    set rcpts to buildRecipientArgs(readGroups(groups))

    repeat with aFile in sFiles
        set src to quoted form of (POSIX path of aFile)
        set dest to (POSIX path of aFile) & ".gpg"
        if confirmEncrypt(dest) then
            encryptFileTo(src, dest, rcpts)
        end if
    end repeat
end fruityGroups

-- Run Main
fruityGroups()

