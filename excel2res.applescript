-- check whether Excel is running
if not application "Microsoft Excel" is running then
	display alert "Microsoft Excel was not running" as critical
	return
end if

tell application "Microsoft Excel"
	activate
	
	-- check whether active sheet eixists
	if not (exists active sheet) then
		display alert "Active sheet was not found" as critical
		return
	end if
	
	-- choose parent folder
	set parentFolder to (choose folder) as string
	log "parentFolder =" & parentFolder
	
	-- search id column
	set columnIndex to 1
	repeat
		set cellValue to value of cell columnIndex of row 2 of active sheet
		if cellValue = "" then
			display alert "id column was not found"
			return
		end if
		if cellValue = "id" then
			set columnIndexId to columnIndex
			exit repeat
		end if
		set columnIndex to columnIndex + 1
	end repeat
	log "columnIndexId=" & columnIndexId
	
	-- create strings.xml for each language
	set columnIndex to 1
	repeat
		set cellValue to value of cell columnIndex of row 2 of active sheet
		if cellValue = "" then exit repeat
		if cellValue ≠ "id" then
			
			-- create folder	
			set folderName to "values"
			if cellValue ≠ "default" then set folderName to folderName & "-" & cellValue
			tell application "Finder"
				try
					make new folder at parentFolder with properties {name:folderName}
				end try
			end tell
			log "folderName=" & folderName
			
			-- create xml
			set xmlStr to "<?xml version=\"1.0\" encoding=\"utf-8\"?>" & linefeed & "<resources>" & linefeed
			set rowIndex to 3
			repeat
				set idValue to value of cell rowIndex of column columnIndexId of active sheet
				if idValue = "" then exit repeat
				set textValue to value of cell rowIndex of column columnIndex of active sheet
				if textValue = "" then exit repeat
				set textValue to replaceText(textValue, "\"", "\\\"") of me
				set textValue to replaceText(textValue, "'", "\\'") of me
				set textValue to replaceText(textValue, "&", "&amp;") of me
				set textValue to replaceText(textValue, "<", "&lt;") of me
				set textValue to replaceText(textValue, ">", "&gt;") of me
				set xmlStr to xmlStr & "<string name=\"" & idValue & "\">" & textValue & "</string>" & linefeed
				set rowIndex to rowIndex + 1
			end repeat
			set xmlStr to xmlStr & "</resources>" & linefeed
			log "directoryName=" & cellValue
			log xmlStr
			
			-- write xml
			tell current application
			set xmlFile to parentFolder & folderName & ":strings.xml"
			set openFile to open for access file xmlFile with write permission
			set eof openFile to 0
			write xmlStr to openFile as «class utf8»
			close access openFile
			end tell
			
		end if
		set columnIndex to columnIndex + 1
	end repeat
	display alert "Conversion completed"
end tell

on replaceText(textValue, serchStr, replaceStr)
	set temp to AppleScript's text item delimiters
	set AppleScript's text item delimiters to serchStr
	set textList to every text item of textValue
	set AppleScript's text item delimiters to replaceStr
	set textValue to textList as string
	set AppleScript's text item delimiters to temp
	return textValue
end replaceText
