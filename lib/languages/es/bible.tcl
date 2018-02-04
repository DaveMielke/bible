proc getOutputEncoding {} {
   return "iso-8859-1"
}

proc getGeneralTitle {} {
   return "La Santa Biblia"
}

proc makeTestamentTitle {type} {
   return "[string totitle $type] Testamento"
}
proc getTestamentTitle_old {} {
   return [makeTestamentTitle "viejo"]
}
proc getTestamentTitle_new {} {
   return [makeTestamentTitle "nuevo"]
}

proc getIndexTitle_book {} {
   return "Índice de Libros"
}
proc getIndexTitle_chapter {} {
   return "Índice de Capítulos"
}
proc getIndexTitle_psalm {} {
   return "Índice de Salmos"
}

proc getChapterTitle_chapter {number} {
   return "Capítulo $number"
}
proc getChapterTitle_psalm {number} {
   return "Salmo $number"
}

proc getLabel_previousBook {} {
   return "Anterior"
}
proc getLabel_bookIndex {} {
   return "Libros"
}
proc getLabel_nextBook {} {
   return "Próximo"
}

proc getLabel_previousChapter {} {
   return "Anterior"
}
proc getLabel_chapterIndex {} {
   return "Capítulos"
}
proc getLabel_nextChapter {} {
   return "Próximo"
}

proc getLabel_search {} {
   return "Busque"
}

proc getSearchTitle {} {
   return "Busque un Versículo"
}
proc setSearchSubstitutions {substitutionsArray} {
   upvar 1 $substitutionsArray substitutions
   set substitutions(instruction.words) "Escriba las palabras que quiere buscar en el formulario siguiente."
   set substitutions(instruction.spaces) "Separe una de la otra con espacios."
   set substitutions(instruction.punctuation) "La puntuación será ignorada."
   set substitutions(instruction.default) "Si no ha cambiado cualesquiera de las opciones siguientes, versículos que contienen todas las palabras especificadas serán encontrados."
   set substitutions(case.statement) "No haga caso de la diferencia entre las letras mayúsculas y minúsculas:"
   set substitutions(case.ignore) "sí"
   set substitutions(case.respect) "no"
   set substitutions(errors.statement) "Permita errores de deletreo (letras incorrectas, adicionales, o que faltan):"
   set substitutions(errors.0) "no"
   set substitutions(errors.1) "uno"
   set substitutions(errors.2) "dos"
   set substitutions(errors.3) "tres"
   set substitutions(errors.4) "cuatro"
   set substitutions(errors.5) "cinco"
   set substitutions(errors.6) "seis"
   set substitutions(errors.7) "siete"
   set substitutions(errors.8) "ocho"
   set substitutions(mode.statement) "Encuentre versículos en los cuales:"
   set substitutions(mode.all) "todas las palabras aparecen"
   set substitutions(mode.any) "cualesquiera de las palabras aparecen"
}

proc getResultsTitle {} {
   return "Los Resultados de la Busquida"
}
proc setResultsSubstitutions {substitutionsArray} {
   upvar 1 $substitutionsArray substitutions
   set substitutions(label.search) "Busque Otra Vez"
   set substitutions(statement.end) "Fin de los resultados de la busquida."
   set substitutions(statement.problem) "El formulario de busquida ha sido llenado incorrectamente."
   set substitutions(input.empty) "El recinto de texto está vacío."
   set substitutions(case.problem) "Una configuuración invalida de sensibilidad de caso ha sido especificada."
   set substitutions(case.ignore) "Caso no importa"
   set substitutions(case.respect) "Caso importa"
   set substitutions(errors.problem) "Un limite de errores ortográficos ha sido especificado."
   set substitutions(mode.problem) "Un modo de selección invalido ha sido especificado."
   set substitutions(mode.all) "Empareja todas las palabras"
   set substitutions(mode.any) "Empareja cualquier palabra"
}
proc getResults_errorsLimit {count} {
   if {$count == 0} {
      return "No permita errores ortográficos."
   }
   if {$count == 1} {
      return "Permita $count error ortográfico."
   }
   return "Permita $count errores ortográficos."
}
proc getResults_versesFound {count} {
   if {$count == 0} {
      return "No se encontraron ningunos versículos."
   }
   if {$count == 1} {
      return "Se encontró $count versículo."
   }
   return "Se encontraron $count versículos."
}

proc getOrdinalPhrase {position object} {
   return "[lindex {Primera Segunda Tercera} [expr {$position - 1}]] de $object"
}

