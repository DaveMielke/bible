proc getOutputEncoding {} {
   return "iso-8859-1"
}

proc getGeneralTitle {} {
   return "The Holy Bible"
}

proc makeTestamentTitle {type} {
   return "[string totitle $type] Testament"
}
proc getTestamentTitle_old {} {
   return [makeTestamentTitle "old"]
}
proc getTestamentTitle_new {} {
   return [makeTestamentTitle "new"]
}

proc makeIndexTitle {type} {
   return "[string totitle $type] Index"
}
proc getIndexTitle_book {} {
   return [makeIndexTitle "book"]
}
proc getIndexTitle_chapter {} {
   return [makeIndexTitle "chapter"]
}
proc getIndexTitle_psalm {} {
   return [makeIndexTitle "psalm"]
}

proc getChapterTitle_chapter {number} {
   return "Chapter $number"
}
proc getChapterTitle_psalm {number} {
   return "Psalm $number"
}

proc getLabel_previousBook {} {
   return "Prev"
}
proc getLabel_bookIndex {} {
   return "Books"
}
proc getLabel_nextBook {} {
   return "Next"
}

proc getLabel_previousChapter {} {
   return "Prev"
}
proc getLabel_chapterIndex {} {
   return "Chapters"
}
proc getLabel_nextChapter {} {
   return "Next"
}

proc getLabel_search {} {
   return "Search"
}

proc getSearchTitle {} {
   return "Find a Verse"
}
proc setSearchSubstitutions {substitutionsArray} {
   upvar 1 $substitutionsArray substitutions

   set substitutions(instruction.words) "Enter the words which you are looking for into the field below."
   set substitutions(instruction.spaces) "Separate them from one another by spaces."
   set substitutions(instruction.punctuation) "Punctuation will be ignored."
   set substitutions(instruction.default) "If you have not changed any of the following options, verses which contain all of the specified words will be found."

   set substitutions(case.statement) "Ignore the difference between capital and small letters:"
   set substitutions(case.ignore) "yes"
   set substitutions(case.respect) "no"

   set substitutions(errors.statement) "Allow spelling errors (wrong, extra, or missing letters):"
   set substitutions(errors.0) "no"
   set substitutions(errors.1) "one"
   set substitutions(errors.2) "two"
   set substitutions(errors.3) "three"
   set substitutions(errors.4) "four"
   set substitutions(errors.5) "five"
   set substitutions(errors.6) "six"
   set substitutions(errors.7) "seven"
   set substitutions(errors.8) "eight"

   set substitutions(mode.statement) "Find those verses in which:"
   set substitutions(mode.all) "all of the words appear"
   set substitutions(mode.any) "any of the words appear"
   set substitutions(mode.phrase) "the phrase appears"

   set substitutions(style.statement) "Show:"
   set substitutions(style.verses) "the references and the verse text"
   set substitutions(style.refs) "just the references"
}

proc getResultsTitle {} {
   return "Search Results"
}
proc setResultsSubstitutions {substitutionsArray} {
   upvar 1 $substitutionsArray substitutions

   set substitutions(label.search) "Search Again"

   set substitutions(statement.end) "End of search results."
   set substitutions(statement.problem) "The search form has been filled out incorrectly."

   set substitutions(input.empty) "The input field is empty."

   set substitutions(case.problem) "An invalid case sensitivity setting has been specified."
   set substitutions(case.ignore) "Case is not significant"
   set substitutions(case.respect) "Case is significant"

   set substitutions(errors.problem) "An invalid spelling error limit has been specified."

   set substitutions(mode.problem) "An invalid selection mode has been specified."
   set substitutions(mode.all) "Match all words"
   set substitutions(mode.any) "Match any word"
   set substitutions(mode.phrase) "Match phrase"

   set substitutions(style.problem) "An invalid result style has been specified."
   set substitutions(style.verses) "Show verses"
   set substitutions(style.refs) "Show references"
}
proc getResults_errorsLimit {count} {
   if {$count == 0} {
      return "don't allow any spelling errors"
   }
   if {$count == 1} {
      return "allow $count spelling error"
   }
   return "allow $count spelling errors"
}
proc getResults_versesFound {count} {
   if {$count == 0} {
      return "No verses were found."
   }
   if {$count == 1} {
      set phrase "verse was"
   } else {
      set phrase "verses were"
   }
   return "$count $phrase found."
}

proc getOrdinalPhrase {position object} {
   return "[lindex {First Second Third} [expr {$position - 1}]] $object"
}

