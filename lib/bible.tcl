source /home/dave/brltty/git/main/brltty-prologue.tcl
lappend auto_path /mnt/opt/dave/lib/tcl

proc setOutputEncoding {stream} {
   fconfigure $stream -encoding [string map {"iso-" "iso"} [getOutputEncoding]]
}

proc getInputEncoding {} {
   return "utf-8"
}

proc openInputStream {path} {
   global bible
   set stream [open $path {RDONLY}]
   fconfigure $stream -encoding [getInputEncoding]
   return $stream
}

proc getBibleDirectory {} {
   global bible
   return "bible-$bible(version)"
}

proc getHypertextDirectory {} {
   return [file join [getBibleDirectory] html]
}

proc getGlimpseDirectory {} {
   return [file join [getBibleDirectory]]
}

proc getVariablesFile {} {
   return [file join [getBibleDirectory] vars]
}

proc getLibraryDirectory {} {
   global bible
   return [file join $bible(root) lib]
}

proc getFilesDirectory {} {
   return [file join [getLibraryDirectory] files]
}

proc getVersionsDirectory {} {
   return [file join [getLibraryDirectory] versions]
}

proc getVersionDirectory {} {
   global bible
   return [file join [getVersionsDirectory] $bible(version)]
}

proc getLanguagesDirectory {} {
   return [file join [getLibraryDirectory] languages]
}

proc getLanguageDirectory {} {
   global bible
   return [file join [getLanguagesDirectory] $bible(language)]
}

proc getBooksFile {} {
   return [file join [getVersionDirectory] books]
}

proc formatBookName {name} {
   regsub -all {_} $name { } name
   return $name
}

proc formatBookTitle {title} {
   regsub -all {_} $title { } title
   return $title
}

proc formatBookParagraphs {paragraphs} {
   set chapters [list]
   foreach chapter [split $paragraphs \;] {
      lappend chapters [split $chapter ,]
   }
   return $chapters
}

proc loadBookDefinitions {} {
   global bible
   set bible(book,keys) [list]
   set bookCount 0
   set stream [openInputStream [set file [getBooksFile]]]
   while {[gets $stream record] >= 0} {
      lassign [lmatch [split [string trim $record]] "?*"] key identifier name chapters title paragraphs
      set bible(book,identifier,$key) $identifier
      set bible(book,name,$key) [formatBookName $name]
      set bible(book,chapters,$key) $chapters
      set bible(book,title,$key) [formatBookTitle $title]
      set bible(book,paragraphs,$key) [formatBookParagraphs $paragraphs]
      set bible(book,index,$key) $bookCount
      set bible(book,key,$bookCount) $key
      lappend bible(book,keys) $key
      incr bookCount
   }
   close $stream; unset stream
   set bible(book,count) $bookCount
}

proc getBookKeys {} {
   global bible
   return $bible(book,keys)
}

proc getBookKey {index} {
   global bible
   return [lindex $bible(book,keys) $index]
}

proc getBookIndex {book} {
   global bible
   return $bible(book,index,$book)
}

proc getBookIdentifier {book} {
   global bible
   return $bible(book,identifier,$book)
}

proc getBookType {book} {
   if {[string equal $book psa]} {
      return "psalm"
   }
   return "chapter"
}

proc getBookName {book} {
   global bible
   return $bible(book,name,$book)
}

proc getBookTitle {book} {
   global bible
   return $bible(book,title,$book)
}

proc getBookPhrase {book} {
   set words [split [getBookName $book] " "]
   if {[regexp {^I+$} [set word [lindex $words 0]]]} {
      set phrase [getOrdinalPhrase [string length $word] [join [lrange $words 1 end] " "]]
   } else {
      set phrase [join $words " "]
   }
   return $phrase
}

proc getBookParagraphs {book} {
   global bible
   return $bible(book,paragraphs,$book)
}

proc getChapterCount {book} {
   global bible
   return $bible(book,chapters,$book)
}

proc getVersesFile {} {
   return [file join [getVersionDirectory] verses]
}

proc getVerseExpression {} {
   return {^\[([A-Z0-9]+)-([0-9]+):([0-9]+)\](?:\[([^]]*)\])? *(.*?) *$}
}

proc getVerseVariables {} {
   return {bookKey chapterNumber verseNumber passageTitle verseText}
}
proc bindVerseVariables {} {
   foreach variable [getVerseVariables] {
      uplevel 1 [list upvar 1 $variable $variable]
   }
}

proc scanVerses {stream code} {
   bindVerseVariables
   set verseVariables  [getVerseVariables]
   set verseExpression  [getVerseExpression]
   while {[gets $stream record] >= 0} {
      if {[eval [list regexp $verseExpression $record line] $verseVariables]} {
         set bookKey [string tolower $bookKey]
         uplevel 1 $code
      } else {
      #  error "invalid verse format: $record"
      }
   }
}

proc forVerses {code} {
   bindVerseVariables
   set stream [openInputStream [getVersesFile]]
   uplevel 1 [list scanVerses $stream $code]
   close $stream; unset stream
}

proc htmlizeVerseText {textVariable} {
   upvar 1 $textVariable text
   regsub -all {\{} $text {<i>} text
   regsub -all {\}} $text {</i>} text
}

proc getDocumentExtension {} {
   return .html
}

proc makeFileURL {components} {
   global bible

   set name [lvarpop components end]
   set folder $bible(document,folder)

   while {!([lempty $folder] || [lempty $components])} {
      if {![cequal [lindex $folder 0] [lindex $components 0]]} {
         break
      }

      lvarpop folder
      lvarpop components
   }

   loop i 0 [llength $folder] {
      lvarpush components ..
   }

   if {[lempty $components]} {
      if {[cequal $name $bible(document,name)]} {
         return ""
      }
   }

   lappend components $name
   return [join $components /]
}

proc getBookURL {index} {
   global bible
   if {(($index < 0) || ($index >= $bible(book,count)))} {
      return ""
   }
   return [makeFileURL [list "[getBookIdentifier [getBookKey $index]][getDocumentExtension]"]]
}

proc getChapterName {chapter} {
   set name $chapter
   while {[clength $name] < 3} {
      set name "0$name"
   }
   return $name
}

proc getChapterURL {book chapter} {
   global bible
   if {(($chapter < 1) || ($chapter > [getChapterCount $book]))} {
      return ""
   }
   return [makeFileURL [list [getBookIdentifier $book] "[getChapterName $chapter][getDocumentExtension]"]]
}

proc markDocument {} {
   global bible
   set mark $bible(document,mark,count)
   set bible(document,mark,$mark) [llength $bible(document,lines)]
   incr bible(document,mark,count)
   return $mark
}

proc insertLine {mark line} {
   global bible
   set bible(document,lines) [linsert $bible(document,lines) $bible(document,mark,$mark) $line]
   incr bible(document,mark,$mark)
}

proc addLine {line} {
   global bible
   lappend bible(document,lines) $line
}

proc addFileReference {text url {image ""}} {
   if {[clength $image] > 0} {
      set text "<img src=\"[makeFileURL [list $image]]\" alt=\"$text\">"
   }

   if {[clength $url] > 0} {
      set text "<a href=\"$url\">$text</a>"
   }

   addLine $text
}

proc addNavigationBar {} {
   global bible

   set previousBook ""
   set bookIndex [makeFileURL [list "index[getDocumentExtension]"]]
   set nextBook ""
   set searchForm [makeFileURL [list "search[getDocumentExtension]"]]
   set strongsForm [makeFileURL [list "strongs[getDocumentExtension]"]]
   set previousChapter ""
   set chapterIndex ""
   set nextChapter ""

   if {$bible(document,type) > 0} {
      global currentBook

      set currentBookIndex [getBookIndex $currentBook]
      set previousBook [getBookURL [expr {$currentBookIndex - 1}]]
      set nextBook [getBookURL [expr {$currentBookIndex + 1}]]
      set chapterIndex [getBookURL $currentBookIndex]

      if {$bible(document,type) > 1} {
	 global currentChapter

	 set previousChapter [getChapterURL $currentBook [expr {$currentChapter - 1}]]
	 set nextChapter [getChapterURL $currentBook [expr {$currentChapter + 1}]]
      }
   }

   addLine "<nav>"
   addLine "<table class=\"navigation-bar\">"
   addLine "<tr>"

   addLine "<td>"
   if {[clength $bookIndex] > 0} {
      addFileReference [getLabel_previousBook] $previousBook "LeftArrow.gif"
      addFileReference [getLabel_bookIndex] $bookIndex
      addFileReference [getLabel_nextBook] $nextBook "RightArrow.gif"
   }
   addLine "</td>"

   addLine "<td>"
   if {[clength $searchForm] > 0} {
      addFileReference [getLabel_search] $searchForm
   }
   if {[clength $strongsForm] > 0} {
      addFileReference [getLabel_strongs] $strongsForm
   }
   addLine "</td>"

   addLine "<td>"
   if {[clength $chapterIndex] > 0} {
      addFileReference [getLabel_previousChapter] $previousChapter "LeftArrow.gif"
      addFileReference [getLabel_chapterIndex] $chapterIndex
      addFileReference [getLabel_nextChapter] $nextChapter "RightArrow.gif"
   }
   addLine "</td>"

   addLine "</tr>"
   addLine "</table>"
   addLine "</nav>"
}

proc startDocument {type path title primaryHeader {secondaryHeader ""}} {
   global bible

   set bible(document,type) $type
   set bible(document,mark,count) 0

   if {[clength [file extension [set bible(document,name) [lvarpop path end]]]] == 0} {
      append bible(document,name) [getDocumentExtension]
   }

   set bible(document,folder) $path
   set bible(document,directory) [eval file join [list [getHypertextDirectory]] $bible(document,folder)]
   set bible(document,file,old) [file join $bible(document,directory) $bible(document,name)]
   set bible(document,file,new) "$bible(document,file,old).new"
   set bible(document,lines) [list]

   addLine "<!DOCTYPE html>"
   addLine "<html lang=\"$bible(language)\">"
   addLine "<head>"
   addLine "<meta charset=\"[string toupper [getOutputEncoding]]\">"
   addLine "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
   addLine "<link rel=\"stylesheet\" href=\"[makeFileURL [list bible.css]]\">"
   addLine "<meta name=\"description\" content=\"$title - Accessible Edition of the $bible(VERSION) ([getGeneralTitle], $bible(title)) with Straightforward Navigation for All Users\">"
   addLine "<title>[getGeneralTitle] - $bible(title) - $title</title>"
   addLine "</head>"

   addLine "<body>"
   addNavigationBar

   addLine "<main>"
   addLine "<h1>$primaryHeader</h1>"

   if {[clength $secondaryHeader] > 0} {
      addLine "<h2>$secondaryHeader</h2>"
   }
}

proc startBasicDocument {name subheader} {
   global bible
   set header "[getGeneralTitle] - $bible(title)"
   startDocument 0 [list $name] $subheader $header $subheader
}

proc writeLines {stream lines} {
   set originalEncoding [fconfigure $stream -encoding]
   setOutputEncoding $stream
   puts $stream [join $lines \n]
   flush $stream
   fconfigure $stream -encoding $originalEncoding
}

proc writeDocument {stream} {
   global bible
   writeLines $stream $bible(document,lines)
}

proc endDocument {{stream ""}} {
   global bible

   addLine "</main>"
   addLine "<hr>"

   addNavigationBar
   addLine "</body>"
   addLine "</html>"

   if {[string length $stream] > 0} {
      writeDocument $stream
   } else {
      file mkdir $bible(document,directory)
      set stream [open $bible(document,file,new) {WRONLY TRUNC CREAT}]
      writeDocument $stream
      close $stream; unset stream
      refreshFile $bible(document,file,new) $bible(document,file,old) 0
   }

   unset bible(document,type)
}

proc documentStarted {} {
   global bible
   return [info exists bible(document,type)]
}

proc addSelector {name value internalList externalList} {
   addLine "<select name=\"$name\">"

   foreach internal $internalList external $externalList {
      if {[cequal $internal $value]} {
         set selected " selected"
      } else {
         set selected ""
      }

      addLine "<option value=\"$internal\"$selected>$external</option>"
   }

   addLine "</select>"
}

proc includeFile {path {substitutionsArray ""}} {
   set map [list]
   if {[string length $substitutionsArray] > 0} {
      upvar 1 $substitutionsArray substitutions
      foreach name [array names substitutions] {
         lappend map "@$name@" $substitutions($name)
      }
   }
   foreach line [readLines $path] {
      addLine [string map $map $line]
   }
}

proc addSearchHelpParagraph {} {
   global bible
   if {[string length [set substitutions(email) [getSearchEmailAddress]]] > 0} {
      addLine "<p>"
      includeFile [file join [getLanguageDirectory] search.help] substitutions
   }
}

proc loadHooks {directory} {
   if {[set ok [file exists [set file [file join $directory "bible.tcl"]]]]} {
      set originalEncoding [encoding system]
      encoding system [getInputEncoding]
      source $file
      encoding system $originalEncoding
   }
   return $ok
}

proc cgiScript {} {
   uplevel #0 {
      source [file join [getLibraryDirectory] "cgi.tcl"]
   }

   proc cgiImport {parameter {default ""}} {
      upvar 1 $parameter $parameter

      try {
         cgi_import $parameter
      } on error {} {
         set $parameter $default
         return 0
      }

      set $parameter [string trim [set $parameter]]
      return 1
   }
}

proc prepareEnvironment {} {
   global bible argv0 env
   set bible(root) [file dirname [file dirname [file normalize $argv0]]]
   if {[info exists env(BIBLE_VERSION)]} {
      set version $env(BIBLE_VERSION)
   } else {
      set version "kjv"
   }
   set bible(version) [string tolower $version]
   set bible(VERSION) [string toupper $version]
   if {![loadHooks [getVersionDirectory]]} {
      putProgramError "unknown Bible version: $bible(version)"
   }
   set bible(title) [getBibleTitle]
   set bible(language) [getLanguageCode]
   if {![loadHooks [getLanguageDirectory]]} {
      putProgramError "unknown language code: $bible(language)"
   }
}

prepareEnvironment
