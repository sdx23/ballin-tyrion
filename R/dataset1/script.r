# Rattle is Copyright (c) 2006-2013 Togaware Pty Ltd.

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:49:43 x86_64-pc-linux-gnu 

# Rattle Version 2.6.26 Benutzer 'mex'

# Exportieren Sie diese Log-Textansicht in eine Datei anhand des Buttons 
# Exportieren oder dem Tools-Menü, um ein Log über alle Aktivitäten zu speichern. Dies vereinfacht Wiederholungen. Exportieren 
# in die Datei 'myrf01.R' ermöglicht z. B., dass man in der R-Konsole den 
# Befehl source('myrf01.R') eingeben kann, um den Ablauf automatisch zu 
# wiederholen. Ggf. möchten wir die Datei für unsere Zwecke bearbeiten. Wir können diese aktuelle Textansicht auch direkt 
# bearbeiten, um zusätzliche Informationen aufzuzeichnen, bevor exportiert wird. 
 
# Beim Speichern und Laden von Projekten bleibt dieses Log ebenfalls erhalten.

library(rattle)

# Diese Log zeichnet üblicherweise die Schritte zum Erstellen eines Modells auf. Mit sehr 
# wenig Aufwand kann es aber verwendet werden, um eine neue Datenreihe anzulegen. Die logische Variable 
# 'building' wird verwendet, um zwischen dem Erstellen von Umwandlungen, wenn ein Modell erstellt 
# wird und dem Verwenden von Umwandlungen, wenn eine Datenreihe angelegt wird, umzuschalten.

building <- TRUE
scoring  <- ! building

# Das Paket Colorspace wird verwendet, um die in den Grafiken vorhandenen Farben zu erzeugen.

library(colorspace)

# Ein vordefinierter Wert wird verwendet, um den zufälligen Startwert  zurück-zusetzen, damit die Ergebnisse wiederholt werden können.

crv$seed <- 42 

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:49:59 x86_64-pc-linux-gnu 

# Die Daten laden

crs$dataset <- read.csv("file:///home/mex/ballin-tyrion/R/dataset1/data.t.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:50:08 x86_64-pc-linux-gnu 

# Die Auswahl des Benutzers beachten 

# Die Training-/Validierungs-/Test-Datenreihen erstellen

set.seed(crv$seed) 
crs$nobs <- nrow(crs$dataset) # 521 observations 
crs$sample <- crs$train <- sample(nrow(crs$dataset), 0.7*crs$nobs) # 364 observations
crs$validate <- sample(setdiff(seq_len(nrow(crs$dataset)), crs$train), 0.15*crs$nobs) # 78 observations
crs$test <- setdiff(setdiff(seq_len(nrow(crs$dataset)), crs$train), crs$validate) # 79 observations

# Die folgenden Variablenauswahl wurde entdeckt.

crs$input <- c("cat", "abby", "ae", "aeroplane",
     "agatha", "alan", "alcott", "alice",
     "amateur", "amfortas", "amo", "amphitryon",
     "amy", "andy", "angus", "ann",
     "anna", "ant", "anthony", "antony",
     "ar", "arabella", "aram", "arch",
     "ari", "armand", "astro", "atkins",
     "augusta", "augustus", "av", "aw",
     "awooing", "ay", "babylonians", "barbara",
     "battalion", "bel", "bella", "benson",
     "beowulf", "berth", "betsy", "billing",
     "blackbird", "bob", "bonaparte", "boone",
     "boris", "boston", "brach", "bramble",
     "bridget", "brooke", "bruin", "brutus",
     "buddha", "ca", "cade", "cadet",
     "cadmus", "caesar", "caithness", "cal",
     "california", "californian", "campbell", "capell",
     "cardinal", "caroline", "carr", "carson",
     "carter", "cassius", "castro", "catherine",
     "celia", "ch", "champlain", "chapter",
     "char", "charmian", "chatterton", "chester",
     "chicago", "chichester", "chipmunk", "chris",
     "christine", "chunky", "claire", "cle",
     "clem", "clerk", "clo", "cob",
     "cocke", "como", "con", "concerto",
     "conj", "cora", "corinne", "cornelia",
     "countess", "crichton", "crofts", "crows",
     "cuckoo", "dad", "dada", "danny",
     "darlin", "dat", "dawson", "dearth",
     "debut", "dec", "delias", "dem",
     "desmond", "dey", "dha", "dick",
     "dionysus", "disuse", "dolls", "domingo",
     "dominican", "don", "dona", "dor",
     "dorcas", "douglas", "dowager", "doyle",
     "duchess", "duke", "dyd", "earl",
     "earldom", "eden", "eds", "edw",
     "ego", "el", "ellipsis", "emilie",
     "erg", "eri", "eriphyle", "ernest",
     "es", "esta", "et", "ethel",
     "euphemia", "excelsis", "fab", "fag",
     "fain", "fal", "fanshaw", "feb",
     "fer", "fergus", "ff", "fletcher",
     "florentines", "flourens", "folkmusic", "footnote",
     "ford", "fran", "frances", "frankie",
     "freddie", "freddy", "froth", "gammon",
     "garcia", "gent", "gila", "giuseppe",
     "gloria", "godolphin", "gordon", "gospels",
     "grail", "greenwood", "gunther", "hale",
     "ham", "hanmer", "hannibal", "harold",
     "harvey", "haue", "hector", "hecuba",
     "heigho", "helen", "helene", "henny",
     "henrik", "hertford", "hippolytus", "hips",
     "hir", "hobson", "hodder", "hortense",
     "howard", "hubbard", "hugh", "hull",
     "huron", "hurra", "hushabye", "hys",
     "ian", "ibsen", "ibsens", "ile",
     "illustration", "imogen", "inter", "iroquois",
     "isa", "isabella", "ivan", "ivanitch",
     "ivanoff", "jack", "jakob", "jan",
     "jane", "jaques", "jasper", "jean",
     "jefferson", "jehovah", "jennie", "jenny",
     "jerry", "jill", "jo", "joanna",
     "jock", "joe", "johnny", "jonathan",
     "jour", "jourdain", "juan", "jul",
     "julian", "julie", "justin", "k",
     "kai", "kala", "karen", "kettle",
     "kirby", "kreutzer", "krishna", "kundry",
     "l", "labrador", "lamarck", "lan",
     "lancelot", "larry", "las", "launce",
     "laura", "lebanon", "lelio", "lenox",
     "leo", "leon", "lesbia", "lieut",
     "lilian", "ling", "liszt", "ll",
     "lo", "loam", "lob", "lomax",
     "lone", "lop", "los", "louisa",
     "louise", "luce", "lucius", "lucy",
     "ludlow", "luke", "lydia", "mabel",
     "mackay", "macpherson", "madam", "maggie",
     "magnus", "maire", "mait", "mal",
     "males", "malvolio", "mangan", "mar",
     "mara", "marchin", "marcus", "margaret",
     "margarita", "marie", "marietta", "marion",
     "marius", "marmaduke", "mary", "mas",
     "matey", "matt", "maud", "maurice",
     "maxwell", "mazzini", "medal", "medina",
     "meeow", "mel", "meleager", "mendelssohn",
     "mer", "merc", "merrythought", "midas",
     "mie", "minnie", "mme", "mohawks",
     "moll", "mollie", "monitor", "mor",
     "moray", "mortimer", "mrs", "muffet",
     "mullins", "n", "nancy", "napoleon",
     "nathan", "ned", "nellie", "nen",
     "nic", "nicola", "nino", "niver",
     "noa", "nobis", "nora", "norse",
     "nov", "oconnell", "oct", "oenone",
     "og", "ol", "olaf", "ole",
     "olivia", "omaha", "omits", "opera",
     "opus", "orchestra", "orkney", "orlando",
     "oswald", "ov", "overture", "p",
     "pansy", "parr", "parsifal", "patch",
     "pearce", "pentheus", "perez", "pero",
     "pete", "petra", "phaedra", "phebe",
     "philharmonic", "philip", "piano", "pickering",
     "pierre", "pindar", "pius", "polly",
     "por", "portsmouth", "pro", "proserpine",
     "proteus", "purdie", "q", "que",
     "quebec", "quixote", "raggedy", "ren",
     "rey", "rhymes", "ricardo", "roberts",
     "rocket", "rosalind", "rowley", "ryder",
     "sanchez", "sancho", "sanctuaries", "santo",
     "schomberg", "scrub", "se", "sec",
     "sergius", "ses", "sez", "sganarelle",
     "shakespeare", "shenandoah", "shirley", "shoo",
     "sidenote", "siegfried", "sil", "silvia",
     "simian", "sinclair", "sissy", "smiley",
     "soa", "sol", "sophy", "sos",
     "species", "spinach", "stephen", "su",
     "sul", "sutherland", "symphonic", "symphony",
     "syr", "taboo", "tad", "talisman",
     "tamburlaine", "ter", "th", "tha",
     "ther", "thers", "theseus", "tim",
     "timothy", "toby", "tom", "touchstone",
     "tra", "trask", "tuneless", "tush",
     "uhhuh", "una", "val", "valentine",
     "variant", "velasco", "vesalius", "virchow",
     "vit", "von", "vor", "wagner",
     "wagners", "wally", "warren", "wel",
     "wer", "whiskey", "wi", "wid",
     "willie", "willis", "willoughby", "wus",
     "wuz", "wycherly", "y", "yeats",
     "yer", "yo", "york", "ys",
     "zee")

crs$numeric <- c("abby", "ae", "aeroplane", "agatha",
     "alan", "alcott", "alice", "amateur",
     "amfortas", "amo", "amphitryon", "amy",
     "andy", "angus", "ann", "anna",
     "ant", "anthony", "antony", "ar",
     "arabella", "aram", "arch", "ari",
     "armand", "astro", "atkins", "augusta",
     "augustus", "av", "aw", "awooing",
     "ay", "babylonians", "barbara", "battalion",
     "bel", "bella", "benson", "beowulf",
     "berth", "betsy", "billing", "blackbird",
     "bob", "bonaparte", "boone", "boris",
     "boston", "brach", "bramble", "bridget",
     "brooke", "bruin", "brutus", "buddha",
     "ca", "cade", "cadet", "cadmus",
     "caesar", "caithness", "cal", "california",
     "californian", "campbell", "capell", "cardinal",
     "caroline", "carr", "carson", "carter",
     "cassius", "castro", "catherine", "celia",
     "ch", "champlain", "chapter", "char",
     "charmian", "chatterton", "chester", "chicago",
     "chichester", "chipmunk", "chris", "christine",
     "chunky", "claire", "cle", "clem",
     "clerk", "clo", "cob", "cocke",
     "como", "con", "concerto", "conj",
     "cora", "corinne", "cornelia", "countess",
     "crichton", "crofts", "crows", "cuckoo",
     "dad", "dada", "danny", "darlin",
     "dat", "dawson", "dearth", "debut",
     "dec", "delias", "dem", "desmond",
     "dey", "dha", "dick", "dionysus",
     "disuse", "dolls", "domingo", "dominican",
     "don", "dona", "dor", "dorcas",
     "douglas", "dowager", "doyle", "duchess",
     "duke", "dyd", "earl", "earldom",
     "eden", "eds", "edw", "ego",
     "el", "ellipsis", "emilie", "erg",
     "eri", "eriphyle", "ernest", "es",
     "esta", "et", "ethel", "euphemia",
     "excelsis", "fab", "fag", "fain",
     "fal", "fanshaw", "feb", "fer",
     "fergus", "ff", "fletcher", "florentines",
     "flourens", "folkmusic", "footnote", "ford",
     "fran", "frances", "frankie", "freddie",
     "freddy", "froth", "gammon", "garcia",
     "gent", "gila", "giuseppe", "gloria",
     "godolphin", "gordon", "gospels", "grail",
     "greenwood", "gunther", "hale", "ham",
     "hanmer", "hannibal", "harold", "harvey",
     "haue", "hector", "hecuba", "heigho",
     "helen", "helene", "henny", "henrik",
     "hertford", "hippolytus", "hips", "hir",
     "hobson", "hodder", "hortense", "howard",
     "hubbard", "hugh", "hull", "huron",
     "hurra", "hushabye", "hys", "ian",
     "ibsen", "ibsens", "ile", "illustration",
     "imogen", "inter", "iroquois", "isa",
     "isabella", "ivan", "ivanitch", "ivanoff",
     "jack", "jakob", "jan", "jane",
     "jaques", "jasper", "jean", "jefferson",
     "jehovah", "jennie", "jenny", "jerry",
     "jill", "jo", "joanna", "jock",
     "joe", "johnny", "jonathan", "jour",
     "jourdain", "juan", "jul", "julian",
     "julie", "justin", "k", "kai",
     "kala", "karen", "kettle", "kirby",
     "kreutzer", "krishna", "kundry", "l",
     "labrador", "lamarck", "lan", "lancelot",
     "larry", "las", "launce", "laura",
     "lebanon", "lelio", "lenox", "leo",
     "leon", "lesbia", "lieut", "lilian",
     "ling", "liszt", "ll", "lo",
     "loam", "lob", "lomax", "lone",
     "lop", "los", "louisa", "louise",
     "luce", "lucius", "lucy", "ludlow",
     "luke", "lydia", "mabel", "mackay",
     "macpherson", "madam", "maggie", "magnus",
     "maire", "mait", "mal", "males",
     "malvolio", "mangan", "mar", "mara",
     "marchin", "marcus", "margaret", "margarita",
     "marie", "marietta", "marion", "marius",
     "marmaduke", "mary", "mas", "matey",
     "matt", "maud", "maurice", "maxwell",
     "mazzini", "medal", "medina", "meeow",
     "mel", "meleager", "mendelssohn", "mer",
     "merc", "merrythought", "midas", "mie",
     "minnie", "mme", "mohawks", "moll",
     "mollie", "monitor", "mor", "moray",
     "mortimer", "mrs", "muffet", "mullins",
     "n", "nancy", "napoleon", "nathan",
     "ned", "nellie", "nen", "nic",
     "nicola", "nino", "niver", "noa",
     "nobis", "nora", "norse", "nov",
     "oconnell", "oct", "oenone", "og",
     "ol", "olaf", "ole", "olivia",
     "omaha", "omits", "opera", "opus",
     "orchestra", "orkney", "orlando", "oswald",
     "ov", "overture", "p", "pansy",
     "parr", "parsifal", "patch", "pearce",
     "pentheus", "perez", "pero", "pete",
     "petra", "phaedra", "phebe", "philharmonic",
     "philip", "piano", "pickering", "pierre",
     "pindar", "pius", "polly", "por",
     "portsmouth", "pro", "proserpine", "proteus",
     "purdie", "q", "que", "quebec",
     "quixote", "raggedy", "ren", "rey",
     "rhymes", "ricardo", "roberts", "rocket",
     "rosalind", "rowley", "ryder", "sanchez",
     "sancho", "sanctuaries", "santo", "schomberg",
     "scrub", "se", "sec", "sergius",
     "ses", "sez", "sganarelle", "shakespeare",
     "shenandoah", "shirley", "shoo", "sidenote",
     "siegfried", "sil", "silvia", "simian",
     "sinclair", "sissy", "smiley", "soa",
     "sol", "sophy", "sos", "species",
     "spinach", "stephen", "su", "sul",
     "sutherland", "symphonic", "symphony", "syr",
     "taboo", "tad", "talisman", "tamburlaine",
     "ter", "th", "tha", "ther",
     "thers", "theseus", "tim", "timothy",
     "toby", "tom", "touchstone", "tra",
     "trask", "tuneless", "tush", "uhhuh",
     "una", "val", "valentine", "variant",
     "velasco", "vesalius", "virchow", "vit",
     "von", "vor", "wagner", "wagners",
     "wally", "warren", "wel", "wer",
     "whiskey", "wi", "wid", "willie",
     "willis", "willoughby", "wus", "wuz",
     "wycherly", "y", "yeats", "yer",
     "yo", "york", "ys", "zee")

crs$categoric <- "cat"

crs$target  <- NULL
crs$risk    <- NULL
crs$ident   <- "word"
crs$ignore  <- NULL
crs$weights <- NULL

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:50:23 x86_64-pc-linux-gnu 

# Die Auswahl des Benutzers beachten 

# Die Training-/Validierungs-/Test-Datenreihen erstellen

set.seed(crv$seed) 
crs$nobs <- nrow(crs$dataset) # 521 observations 
crs$sample <- crs$train <- sample(nrow(crs$dataset), 0.7*crs$nobs) # 364 observations
crs$validate <- sample(setdiff(seq_len(nrow(crs$dataset)), crs$train), 0.15*crs$nobs) # 78 observations
crs$test <- setdiff(setdiff(seq_len(nrow(crs$dataset)), crs$train), crs$validate) # 79 observations

# Die folgenden Variablenauswahl wurde entdeckt.

crs$input <- c("abby", "ae", "aeroplane", "agatha",
     "alan", "alcott", "alice", "amateur",
     "amfortas", "amo", "amphitryon", "amy",
     "andy", "angus", "ann", "anna",
     "ant", "anthony", "antony", "ar",
     "arabella", "aram", "arch", "ari",
     "armand", "astro", "atkins", "augusta",
     "augustus", "av", "aw", "awooing",
     "ay", "babylonians", "barbara", "battalion",
     "bel", "bella", "benson", "beowulf",
     "berth", "betsy", "billing", "blackbird",
     "bob", "bonaparte", "boone", "boris",
     "boston", "brach", "bramble", "bridget",
     "brooke", "bruin", "brutus", "buddha",
     "ca", "cade", "cadet", "cadmus",
     "caesar", "caithness", "cal", "california",
     "californian", "campbell", "capell", "cardinal",
     "caroline", "carr", "carson", "carter",
     "cassius", "castro", "catherine", "celia",
     "ch", "champlain", "chapter", "char",
     "charmian", "chatterton", "chester", "chicago",
     "chichester", "chipmunk", "chris", "christine",
     "chunky", "claire", "cle", "clem",
     "clerk", "clo", "cob", "cocke",
     "como", "con", "concerto", "conj",
     "cora", "corinne", "cornelia", "countess",
     "crichton", "crofts", "crows", "cuckoo",
     "dad", "dada", "danny", "darlin",
     "dat", "dawson", "dearth", "debut",
     "dec", "delias", "dem", "desmond",
     "dey", "dha", "dick", "dionysus",
     "disuse", "dolls", "domingo", "dominican",
     "don", "dona", "dor", "dorcas",
     "douglas", "dowager", "doyle", "duchess",
     "duke", "dyd", "earl", "earldom",
     "eden", "eds", "edw", "ego",
     "el", "ellipsis", "emilie", "erg",
     "eri", "eriphyle", "ernest", "es",
     "esta", "et", "ethel", "euphemia",
     "excelsis", "fab", "fag", "fain",
     "fal", "fanshaw", "feb", "fer",
     "fergus", "ff", "fletcher", "florentines",
     "flourens", "folkmusic", "footnote", "ford",
     "fran", "frances", "frankie", "freddie",
     "freddy", "froth", "gammon", "garcia",
     "gent", "gila", "giuseppe", "gloria",
     "godolphin", "gordon", "gospels", "grail",
     "greenwood", "gunther", "hale", "ham",
     "hanmer", "hannibal", "harold", "harvey",
     "haue", "hector", "hecuba", "heigho",
     "helen", "helene", "henny", "henrik",
     "hertford", "hippolytus", "hips", "hir",
     "hobson", "hodder", "hortense", "howard",
     "hubbard", "hugh", "hull", "huron",
     "hurra", "hushabye", "hys", "ian",
     "ibsen", "ibsens", "ile", "illustration",
     "imogen", "inter", "iroquois", "isa",
     "isabella", "ivan", "ivanitch", "ivanoff",
     "jack", "jakob", "jan", "jane",
     "jaques", "jasper", "jean", "jefferson",
     "jehovah", "jennie", "jenny", "jerry",
     "jill", "jo", "joanna", "jock",
     "joe", "johnny", "jonathan", "jour",
     "jourdain", "juan", "jul", "julian",
     "julie", "justin", "k", "kai",
     "kala", "karen", "kettle", "kirby",
     "kreutzer", "krishna", "kundry", "l",
     "labrador", "lamarck", "lan", "lancelot",
     "larry", "las", "launce", "laura",
     "lebanon", "lelio", "lenox", "leo",
     "leon", "lesbia", "lieut", "lilian",
     "ling", "liszt", "ll", "lo",
     "loam", "lob", "lomax", "lone",
     "lop", "los", "louisa", "louise",
     "luce", "lucius", "lucy", "ludlow",
     "luke", "lydia", "mabel", "mackay",
     "macpherson", "madam", "maggie", "magnus",
     "maire", "mait", "mal", "males",
     "malvolio", "mangan", "mar", "mara",
     "marchin", "marcus", "margaret", "margarita",
     "marie", "marietta", "marion", "marius",
     "marmaduke", "mary", "mas", "matey",
     "matt", "maud", "maurice", "maxwell",
     "mazzini", "medal", "medina", "meeow",
     "mel", "meleager", "mendelssohn", "mer",
     "merc", "merrythought", "midas", "mie",
     "minnie", "mme", "mohawks", "moll",
     "mollie", "monitor", "mor", "moray",
     "mortimer", "mrs", "muffet", "mullins",
     "n", "nancy", "napoleon", "nathan",
     "ned", "nellie", "nen", "nic",
     "nicola", "nino", "niver", "noa",
     "nobis", "nora", "norse", "nov",
     "oconnell", "oct", "oenone", "og",
     "ol", "olaf", "ole", "olivia",
     "omaha", "omits", "opera", "opus",
     "orchestra", "orkney", "orlando", "oswald",
     "ov", "overture", "p", "pansy",
     "parr", "parsifal", "patch", "pearce",
     "pentheus", "perez", "pero", "pete",
     "petra", "phaedra", "phebe", "philharmonic",
     "philip", "piano", "pickering", "pierre",
     "pindar", "pius", "polly", "por",
     "portsmouth", "pro", "proserpine", "proteus",
     "purdie", "q", "que", "quebec",
     "quixote", "raggedy", "ren", "rey",
     "rhymes", "ricardo", "roberts", "rocket",
     "rosalind", "rowley", "ryder", "sanchez",
     "sancho", "sanctuaries", "santo", "schomberg",
     "scrub", "se", "sec", "sergius",
     "ses", "sez", "sganarelle", "shakespeare",
     "shenandoah", "shirley", "shoo", "sidenote",
     "siegfried", "sil", "silvia", "simian",
     "sinclair", "sissy", "smiley", "soa",
     "sol", "sophy", "sos", "species",
     "spinach", "stephen", "su", "sul",
     "sutherland", "symphonic", "symphony", "syr",
     "taboo", "tad", "talisman", "tamburlaine",
     "ter", "th", "tha", "ther",
     "thers", "theseus", "tim", "timothy",
     "toby", "tom", "touchstone", "tra",
     "trask", "tuneless", "tush", "uhhuh",
     "una", "val", "valentine", "variant",
     "velasco", "vesalius", "virchow", "vit",
     "von", "vor", "wagner", "wagners",
     "wally", "warren", "wel", "wer",
     "whiskey", "wi", "wid", "willie",
     "willis", "willoughby", "wus", "wuz",
     "wycherly", "y", "yeats", "yer",
     "yo", "york", "ys", "zee")

crs$numeric <- c("abby", "ae", "aeroplane", "agatha",
     "alan", "alcott", "alice", "amateur",
     "amfortas", "amo", "amphitryon", "amy",
     "andy", "angus", "ann", "anna",
     "ant", "anthony", "antony", "ar",
     "arabella", "aram", "arch", "ari",
     "armand", "astro", "atkins", "augusta",
     "augustus", "av", "aw", "awooing",
     "ay", "babylonians", "barbara", "battalion",
     "bel", "bella", "benson", "beowulf",
     "berth", "betsy", "billing", "blackbird",
     "bob", "bonaparte", "boone", "boris",
     "boston", "brach", "bramble", "bridget",
     "brooke", "bruin", "brutus", "buddha",
     "ca", "cade", "cadet", "cadmus",
     "caesar", "caithness", "cal", "california",
     "californian", "campbell", "capell", "cardinal",
     "caroline", "carr", "carson", "carter",
     "cassius", "castro", "catherine", "celia",
     "ch", "champlain", "chapter", "char",
     "charmian", "chatterton", "chester", "chicago",
     "chichester", "chipmunk", "chris", "christine",
     "chunky", "claire", "cle", "clem",
     "clerk", "clo", "cob", "cocke",
     "como", "con", "concerto", "conj",
     "cora", "corinne", "cornelia", "countess",
     "crichton", "crofts", "crows", "cuckoo",
     "dad", "dada", "danny", "darlin",
     "dat", "dawson", "dearth", "debut",
     "dec", "delias", "dem", "desmond",
     "dey", "dha", "dick", "dionysus",
     "disuse", "dolls", "domingo", "dominican",
     "don", "dona", "dor", "dorcas",
     "douglas", "dowager", "doyle", "duchess",
     "duke", "dyd", "earl", "earldom",
     "eden", "eds", "edw", "ego",
     "el", "ellipsis", "emilie", "erg",
     "eri", "eriphyle", "ernest", "es",
     "esta", "et", "ethel", "euphemia",
     "excelsis", "fab", "fag", "fain",
     "fal", "fanshaw", "feb", "fer",
     "fergus", "ff", "fletcher", "florentines",
     "flourens", "folkmusic", "footnote", "ford",
     "fran", "frances", "frankie", "freddie",
     "freddy", "froth", "gammon", "garcia",
     "gent", "gila", "giuseppe", "gloria",
     "godolphin", "gordon", "gospels", "grail",
     "greenwood", "gunther", "hale", "ham",
     "hanmer", "hannibal", "harold", "harvey",
     "haue", "hector", "hecuba", "heigho",
     "helen", "helene", "henny", "henrik",
     "hertford", "hippolytus", "hips", "hir",
     "hobson", "hodder", "hortense", "howard",
     "hubbard", "hugh", "hull", "huron",
     "hurra", "hushabye", "hys", "ian",
     "ibsen", "ibsens", "ile", "illustration",
     "imogen", "inter", "iroquois", "isa",
     "isabella", "ivan", "ivanitch", "ivanoff",
     "jack", "jakob", "jan", "jane",
     "jaques", "jasper", "jean", "jefferson",
     "jehovah", "jennie", "jenny", "jerry",
     "jill", "jo", "joanna", "jock",
     "joe", "johnny", "jonathan", "jour",
     "jourdain", "juan", "jul", "julian",
     "julie", "justin", "k", "kai",
     "kala", "karen", "kettle", "kirby",
     "kreutzer", "krishna", "kundry", "l",
     "labrador", "lamarck", "lan", "lancelot",
     "larry", "las", "launce", "laura",
     "lebanon", "lelio", "lenox", "leo",
     "leon", "lesbia", "lieut", "lilian",
     "ling", "liszt", "ll", "lo",
     "loam", "lob", "lomax", "lone",
     "lop", "los", "louisa", "louise",
     "luce", "lucius", "lucy", "ludlow",
     "luke", "lydia", "mabel", "mackay",
     "macpherson", "madam", "maggie", "magnus",
     "maire", "mait", "mal", "males",
     "malvolio", "mangan", "mar", "mara",
     "marchin", "marcus", "margaret", "margarita",
     "marie", "marietta", "marion", "marius",
     "marmaduke", "mary", "mas", "matey",
     "matt", "maud", "maurice", "maxwell",
     "mazzini", "medal", "medina", "meeow",
     "mel", "meleager", "mendelssohn", "mer",
     "merc", "merrythought", "midas", "mie",
     "minnie", "mme", "mohawks", "moll",
     "mollie", "monitor", "mor", "moray",
     "mortimer", "mrs", "muffet", "mullins",
     "n", "nancy", "napoleon", "nathan",
     "ned", "nellie", "nen", "nic",
     "nicola", "nino", "niver", "noa",
     "nobis", "nora", "norse", "nov",
     "oconnell", "oct", "oenone", "og",
     "ol", "olaf", "ole", "olivia",
     "omaha", "omits", "opera", "opus",
     "orchestra", "orkney", "orlando", "oswald",
     "ov", "overture", "p", "pansy",
     "parr", "parsifal", "patch", "pearce",
     "pentheus", "perez", "pero", "pete",
     "petra", "phaedra", "phebe", "philharmonic",
     "philip", "piano", "pickering", "pierre",
     "pindar", "pius", "polly", "por",
     "portsmouth", "pro", "proserpine", "proteus",
     "purdie", "q", "que", "quebec",
     "quixote", "raggedy", "ren", "rey",
     "rhymes", "ricardo", "roberts", "rocket",
     "rosalind", "rowley", "ryder", "sanchez",
     "sancho", "sanctuaries", "santo", "schomberg",
     "scrub", "se", "sec", "sergius",
     "ses", "sez", "sganarelle", "shakespeare",
     "shenandoah", "shirley", "shoo", "sidenote",
     "siegfried", "sil", "silvia", "simian",
     "sinclair", "sissy", "smiley", "soa",
     "sol", "sophy", "sos", "species",
     "spinach", "stephen", "su", "sul",
     "sutherland", "symphonic", "symphony", "syr",
     "taboo", "tad", "talisman", "tamburlaine",
     "ter", "th", "tha", "ther",
     "thers", "theseus", "tim", "timothy",
     "toby", "tom", "touchstone", "tra",
     "trask", "tuneless", "tush", "uhhuh",
     "una", "val", "valentine", "variant",
     "velasco", "vesalius", "virchow", "vit",
     "von", "vor", "wagner", "wagners",
     "wally", "warren", "wel", "wer",
     "whiskey", "wi", "wid", "willie",
     "willis", "willoughby", "wus", "wuz",
     "wycherly", "y", "yeats", "yer",
     "yo", "york", "ys", "zee")

crs$categoric <- NULL

crs$target  <- "cat"
crs$risk    <- NULL
crs$ident   <- "word"
crs$ignore  <- NULL
crs$weights <- NULL

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:51:43 x86_64-pc-linux-gnu 

# Die Auswahl des Benutzers beachten 

# Die Training-/Validierungs-/Test-Datenreihen erstellen

set.seed(crv$seed) 
crs$nobs <- nrow(crs$dataset) # 521 observations 
crs$sample <- crs$train <- sample(nrow(crs$dataset), 0.7*crs$nobs) # 364 observations
crs$validate <- sample(setdiff(seq_len(nrow(crs$dataset)), crs$train), 0.15*crs$nobs) # 78 observations
crs$test <- setdiff(setdiff(seq_len(nrow(crs$dataset)), crs$train), crs$validate) # 79 observations

# Die folgenden Variablenauswahl wurde entdeckt.

crs$input <- c("abby", "ae", "aeroplane", "agatha",
     "alan", "alcott", "alice", "amateur",
     "amfortas", "amo", "amphitryon", "amy",
     "andy", "angus", "ann", "anna",
     "ant", "anthony", "antony", "ar",
     "arabella", "aram", "arch", "ari",
     "armand", "astro", "atkins", "augusta",
     "augustus", "av", "aw", "awooing",
     "ay", "babylonians", "barbara", "battalion",
     "bel", "bella", "benson", "beowulf",
     "berth", "betsy", "billing", "blackbird",
     "bob", "bonaparte", "boone", "boris",
     "boston", "brach", "bramble", "bridget",
     "brooke", "bruin", "brutus", "buddha",
     "ca", "cade", "cadet", "cadmus",
     "caesar", "caithness", "cal", "california",
     "californian", "campbell", "capell", "cardinal",
     "caroline", "carr", "carson", "carter",
     "cassius", "castro", "catherine", "celia",
     "ch", "champlain", "chapter", "char",
     "charmian", "chatterton", "chester", "chicago",
     "chichester", "chipmunk", "chris", "christine",
     "chunky", "claire", "cle", "clem",
     "clerk", "clo", "cob", "cocke",
     "como", "con", "concerto", "conj",
     "cora", "corinne", "cornelia", "countess",
     "crichton", "crofts", "crows", "cuckoo",
     "dad", "dada", "danny", "darlin",
     "dat", "dawson", "dearth", "debut",
     "dec", "delias", "dem", "desmond",
     "dey", "dha", "dick", "dionysus",
     "disuse", "dolls", "domingo", "dominican",
     "don", "dona", "dor", "dorcas",
     "douglas", "dowager", "doyle", "duchess",
     "duke", "dyd", "earl", "earldom",
     "eden", "eds", "edw", "ego",
     "el", "ellipsis", "emilie", "erg",
     "eri", "eriphyle", "ernest", "es",
     "esta", "et", "ethel", "euphemia",
     "excelsis", "fab", "fag", "fain",
     "fal", "fanshaw", "feb", "fer",
     "fergus", "ff", "fletcher", "florentines",
     "flourens", "folkmusic", "footnote", "ford",
     "fran", "frances", "frankie", "freddie",
     "freddy", "froth", "gammon", "garcia",
     "gent", "gila", "giuseppe", "gloria",
     "godolphin", "gordon", "gospels", "grail",
     "greenwood", "gunther", "hale", "ham",
     "hanmer", "hannibal", "harold", "harvey",
     "haue", "hector", "hecuba", "heigho",
     "helen", "helene", "henny", "henrik",
     "hertford", "hippolytus", "hips", "hir",
     "hobson", "hodder", "hortense", "howard",
     "hubbard", "hugh", "hull", "huron",
     "hurra", "hushabye", "hys", "ian",
     "ibsen", "ibsens", "ile", "illustration",
     "imogen", "inter", "iroquois", "isa",
     "isabella", "ivan", "ivanitch", "ivanoff",
     "jack", "jakob", "jan", "jane",
     "jaques", "jasper", "jean", "jefferson",
     "jehovah", "jennie", "jenny", "jerry",
     "jill", "jo", "joanna", "jock",
     "joe", "johnny", "jonathan", "jour",
     "jourdain", "juan", "jul", "julian",
     "julie", "justin", "k", "kai",
     "kala", "karen", "kettle", "kirby",
     "kreutzer", "krishna", "kundry", "l",
     "labrador", "lamarck", "lan", "lancelot",
     "larry", "las", "launce", "laura",
     "lebanon", "lelio", "lenox", "leo",
     "leon", "lesbia", "lieut", "lilian",
     "ling", "liszt", "ll", "lo",
     "loam", "lob", "lomax", "lone",
     "lop", "los", "louisa", "louise",
     "luce", "lucius", "lucy", "ludlow",
     "luke", "lydia", "mabel", "mackay",
     "macpherson", "madam", "maggie", "magnus",
     "maire", "mait", "mal", "males",
     "malvolio", "mangan", "mar", "mara",
     "marchin", "marcus", "margaret", "margarita",
     "marie", "marietta", "marion", "marius",
     "marmaduke", "mary", "mas", "matey",
     "matt", "maud", "maurice", "maxwell",
     "mazzini", "medal", "medina", "meeow",
     "mel", "meleager", "mendelssohn", "mer",
     "merc", "merrythought", "midas", "mie",
     "minnie", "mme", "mohawks", "moll",
     "mollie", "monitor", "mor", "moray",
     "mortimer", "mrs", "muffet", "mullins",
     "n", "nancy", "napoleon", "nathan",
     "ned", "nellie", "nen", "nic",
     "nicola", "nino", "niver", "noa",
     "nobis", "nora", "norse", "nov",
     "oconnell", "oct", "oenone", "og",
     "ol", "olaf", "ole", "olivia",
     "omaha", "omits", "opera", "opus",
     "orchestra", "orkney", "orlando", "oswald",
     "ov", "overture", "p", "pansy",
     "parr", "parsifal", "patch", "pearce",
     "pentheus", "perez", "pero", "pete",
     "petra", "phaedra", "phebe", "philharmonic",
     "philip", "piano", "pickering", "pierre",
     "pindar", "pius", "polly", "por",
     "portsmouth", "pro", "proserpine", "proteus",
     "purdie", "q", "que", "quebec",
     "quixote", "raggedy", "ren", "rey",
     "rhymes", "ricardo", "roberts", "rocket",
     "rosalind", "rowley", "ryder", "sanchez",
     "sancho", "sanctuaries", "santo", "schomberg",
     "scrub", "se", "sec", "sergius",
     "ses", "sez", "sganarelle", "shakespeare",
     "shenandoah", "shirley", "shoo", "sidenote",
     "siegfried", "sil", "silvia", "simian",
     "sinclair", "sissy", "smiley", "soa",
     "sol", "sophy", "sos", "species",
     "spinach", "stephen", "su", "sul",
     "sutherland", "symphonic", "symphony", "syr",
     "taboo", "tad", "talisman", "tamburlaine",
     "ter", "th", "tha", "ther",
     "thers", "theseus", "tim", "timothy",
     "toby", "tom", "touchstone", "tra",
     "trask", "tuneless", "tush", "uhhuh",
     "una", "val", "valentine", "variant",
     "velasco", "vesalius", "virchow", "vit",
     "von", "vor", "wagner", "wagners",
     "wally", "warren", "wel", "wer",
     "whiskey", "wi", "wid", "willie",
     "willis", "willoughby", "wus", "wuz",
     "wycherly", "y", "yeats", "yer",
     "yo", "york", "ys", "zee")

crs$numeric <- c("abby", "ae", "aeroplane", "agatha",
     "alan", "alcott", "alice", "amateur",
     "amfortas", "amo", "amphitryon", "amy",
     "andy", "angus", "ann", "anna",
     "ant", "anthony", "antony", "ar",
     "arabella", "aram", "arch", "ari",
     "armand", "astro", "atkins", "augusta",
     "augustus", "av", "aw", "awooing",
     "ay", "babylonians", "barbara", "battalion",
     "bel", "bella", "benson", "beowulf",
     "berth", "betsy", "billing", "blackbird",
     "bob", "bonaparte", "boone", "boris",
     "boston", "brach", "bramble", "bridget",
     "brooke", "bruin", "brutus", "buddha",
     "ca", "cade", "cadet", "cadmus",
     "caesar", "caithness", "cal", "california",
     "californian", "campbell", "capell", "cardinal",
     "caroline", "carr", "carson", "carter",
     "cassius", "castro", "catherine", "celia",
     "ch", "champlain", "chapter", "char",
     "charmian", "chatterton", "chester", "chicago",
     "chichester", "chipmunk", "chris", "christine",
     "chunky", "claire", "cle", "clem",
     "clerk", "clo", "cob", "cocke",
     "como", "con", "concerto", "conj",
     "cora", "corinne", "cornelia", "countess",
     "crichton", "crofts", "crows", "cuckoo",
     "dad", "dada", "danny", "darlin",
     "dat", "dawson", "dearth", "debut",
     "dec", "delias", "dem", "desmond",
     "dey", "dha", "dick", "dionysus",
     "disuse", "dolls", "domingo", "dominican",
     "don", "dona", "dor", "dorcas",
     "douglas", "dowager", "doyle", "duchess",
     "duke", "dyd", "earl", "earldom",
     "eden", "eds", "edw", "ego",
     "el", "ellipsis", "emilie", "erg",
     "eri", "eriphyle", "ernest", "es",
     "esta", "et", "ethel", "euphemia",
     "excelsis", "fab", "fag", "fain",
     "fal", "fanshaw", "feb", "fer",
     "fergus", "ff", "fletcher", "florentines",
     "flourens", "folkmusic", "footnote", "ford",
     "fran", "frances", "frankie", "freddie",
     "freddy", "froth", "gammon", "garcia",
     "gent", "gila", "giuseppe", "gloria",
     "godolphin", "gordon", "gospels", "grail",
     "greenwood", "gunther", "hale", "ham",
     "hanmer", "hannibal", "harold", "harvey",
     "haue", "hector", "hecuba", "heigho",
     "helen", "helene", "henny", "henrik",
     "hertford", "hippolytus", "hips", "hir",
     "hobson", "hodder", "hortense", "howard",
     "hubbard", "hugh", "hull", "huron",
     "hurra", "hushabye", "hys", "ian",
     "ibsen", "ibsens", "ile", "illustration",
     "imogen", "inter", "iroquois", "isa",
     "isabella", "ivan", "ivanitch", "ivanoff",
     "jack", "jakob", "jan", "jane",
     "jaques", "jasper", "jean", "jefferson",
     "jehovah", "jennie", "jenny", "jerry",
     "jill", "jo", "joanna", "jock",
     "joe", "johnny", "jonathan", "jour",
     "jourdain", "juan", "jul", "julian",
     "julie", "justin", "k", "kai",
     "kala", "karen", "kettle", "kirby",
     "kreutzer", "krishna", "kundry", "l",
     "labrador", "lamarck", "lan", "lancelot",
     "larry", "las", "launce", "laura",
     "lebanon", "lelio", "lenox", "leo",
     "leon", "lesbia", "lieut", "lilian",
     "ling", "liszt", "ll", "lo",
     "loam", "lob", "lomax", "lone",
     "lop", "los", "louisa", "louise",
     "luce", "lucius", "lucy", "ludlow",
     "luke", "lydia", "mabel", "mackay",
     "macpherson", "madam", "maggie", "magnus",
     "maire", "mait", "mal", "males",
     "malvolio", "mangan", "mar", "mara",
     "marchin", "marcus", "margaret", "margarita",
     "marie", "marietta", "marion", "marius",
     "marmaduke", "mary", "mas", "matey",
     "matt", "maud", "maurice", "maxwell",
     "mazzini", "medal", "medina", "meeow",
     "mel", "meleager", "mendelssohn", "mer",
     "merc", "merrythought", "midas", "mie",
     "minnie", "mme", "mohawks", "moll",
     "mollie", "monitor", "mor", "moray",
     "mortimer", "mrs", "muffet", "mullins",
     "n", "nancy", "napoleon", "nathan",
     "ned", "nellie", "nen", "nic",
     "nicola", "nino", "niver", "noa",
     "nobis", "nora", "norse", "nov",
     "oconnell", "oct", "oenone", "og",
     "ol", "olaf", "ole", "olivia",
     "omaha", "omits", "opera", "opus",
     "orchestra", "orkney", "orlando", "oswald",
     "ov", "overture", "p", "pansy",
     "parr", "parsifal", "patch", "pearce",
     "pentheus", "perez", "pero", "pete",
     "petra", "phaedra", "phebe", "philharmonic",
     "philip", "piano", "pickering", "pierre",
     "pindar", "pius", "polly", "por",
     "portsmouth", "pro", "proserpine", "proteus",
     "purdie", "q", "que", "quebec",
     "quixote", "raggedy", "ren", "rey",
     "rhymes", "ricardo", "roberts", "rocket",
     "rosalind", "rowley", "ryder", "sanchez",
     "sancho", "sanctuaries", "santo", "schomberg",
     "scrub", "se", "sec", "sergius",
     "ses", "sez", "sganarelle", "shakespeare",
     "shenandoah", "shirley", "shoo", "sidenote",
     "siegfried", "sil", "silvia", "simian",
     "sinclair", "sissy", "smiley", "soa",
     "sol", "sophy", "sos", "species",
     "spinach", "stephen", "su", "sul",
     "sutherland", "symphonic", "symphony", "syr",
     "taboo", "tad", "talisman", "tamburlaine",
     "ter", "th", "tha", "ther",
     "thers", "theseus", "tim", "timothy",
     "toby", "tom", "touchstone", "tra",
     "trask", "tuneless", "tush", "uhhuh",
     "una", "val", "valentine", "variant",
     "velasco", "vesalius", "virchow", "vit",
     "von", "vor", "wagner", "wagners",
     "wally", "warren", "wel", "wer",
     "whiskey", "wi", "wid", "willie",
     "willis", "willoughby", "wus", "wuz",
     "wycherly", "y", "yeats", "yer",
     "yo", "york", "ys", "zee")

crs$categoric <- NULL

crs$target  <- "cat"
crs$risk    <- NULL
crs$ident   <- "word"
crs$ignore  <- NULL
crs$weights <- NULL

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:06 x86_64-pc-linux-gnu 

# K-Means 

# Die erste Zufallszahl zurücksetzen, sodass immmer die gleichen Ergebnisse erhalten werden

set.seed(crv$seed)

# Einen K-Means-Cluster der Größe 10 erstellen

crs$kmeans <- kmeans(na.omit(crs$dataset[crs$sample, crs$numeric]), 10)

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:07 x86_64-pc-linux-gnu 

# Report über die Cluster-Characteristiken 

# Cluster-Größe:

paste(crs$kmeans$size, collapse=' ')

# Daten-Mittelwerte:

colMeans(na.omit(crs$dataset[crs$sample, crs$numeric]))

# Cluster-Zentren:

crs$kmeans$centers

# Innerhalb Cluster-Qudratsumme:

crs$kmeans$withinss

# Benötigte Zeit: 0.22 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:14 x86_64-pc-linux-gnu 

# K-Means 

# Die erste Zufallszahl zurücksetzen, sodass immmer die gleichen Ergebnisse erhalten werden

set.seed(crv$seed)

# Einen K-Means-Cluster der Größe 6 erstellen

crs$kmeans <- kmeans(na.omit(crs$dataset[crs$sample, crs$numeric]), 6)

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:14 x86_64-pc-linux-gnu 

# Report über die Cluster-Characteristiken 

# Cluster-Größe:

paste(crs$kmeans$size, collapse=' ')

# Daten-Mittelwerte:

colMeans(na.omit(crs$dataset[crs$sample, crs$numeric]))

# Cluster-Zentren:

crs$kmeans$centers

# Innerhalb Cluster-Qudratsumme:

crs$kmeans$withinss

# Benötigte Zeit: 0.30 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:19 x86_64-pc-linux-gnu 

# Entropy Weighted KMeans 

# Das Paket 'weightedKmeans' stellt die Funktion 'ewkm' zur Verfügung.

require(weightedKmeans, quietly=TRUE)

# Die erste Zufallszahl zurücksetzen, sodass immmer die gleichen Ergebnisse erhalten werden

set.seed(crv$seed)

# Generate a ewkm cluster of size 6.

crs$kmeans <- ewkm(na.omit(crs$dataset[crs$sample, crs$numeric]), 6)

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:21 x86_64-pc-linux-gnu 

# Report über die Cluster-Characteristiken 

# Cluster-Größe:

paste(crs$kmeans$size, collapse=' ')

# Daten-Mittelwerte:

colMeans(na.omit(crs$dataset[crs$sample, crs$numeric]))

# Cluster-Zentren:

crs$kmeans$centers

# Cluster weights:

round(crs$kmeans$weights, 2)

# Innerhalb Cluster-Qudratsumme:

crs$kmeans$withinss

# Benötigte Zeit: 0.13 Sek

# Das Paket 'amap' stellt die Funktion 'hclusterpar' zur Verfügung.

require(amap, quietly=TRUE)

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:52:48 x86_64-pc-linux-gnu 

# Hierarchische Cluster 

# Ein hierarchisches Cluster der Daten erstellen

crs$hclust <- 

# Das Paket 'amap' stellt die Funktion 'hclusterpar' zur Verfügung.

require(amap, quietly=TRUE)

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:53:07 x86_64-pc-linux-gnu 

# Hierarchische Cluster 

# Ein hierarchisches Cluster der Daten erstellen

crs$hclust <- 

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:53:48 x86_64-pc-linux-gnu 

# Entscheidungsstruktur 

# Das Paket 'rpart' stellt die Funktion 'rpart' zur Verfügung.

require(rpart, quietly=TRUE)

# Die erste Zufallszahl zurücksetzen, sodass immmer die gleichen Ergebnisse erhalten werden

set.seed(crv$seed)

# Das Entscheidungsstruktur-Modell erstellen

crs$rpart <- rpart(cat ~ .,
    data=crs$dataset[crs$train, c(crs$input, crs$target)],
    method="class",
    parms=list(split="information"),
    control=rpart.control(usesurrogate=0, 
        maxsurrogate=0))

# Eine Textansicht des Modells Entscheidungsstruktur erstellen

print(crs$rpart)
printcp(crs$rpart)
cat("\n")

# Benötigte Zeit: 1.81 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:54:18 x86_64-pc-linux-gnu 

# Random Forest 

# Das Paket 'randomForest' stellt die Funktion 'randomForest' zur Verfügung.

require(randomForest, quietly=TRUE)

# Das Random Forest-Modell erstellen

set.seed(crv$seed)
crs$rf <- randomForest(cat ~ .,
      data=crs$dataset[crs$sample,c(crs$input, crs$target)], 
      ntree=500,
      mtry=22,
      importance=TRUE,
      na.action=na.omit,
      replace=FALSE)

# Die Textausgabe des Modells 'Random Forest' erstellen

crs$rf

# Die Wicktigkeit der Variablen auflisten

rn <- round(importance(crs$rf), 2)
rn[order(rn[,3], decreasing=TRUE),]

# Benötigte Zeit: 17.63 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:54:50 x86_64-pc-linux-gnu 

# Random Forest 

# Das Paket 'randomForest' stellt die Funktion 'randomForest' zur Verfügung.

require(randomForest, quietly=TRUE)

# Das Random Forest-Modell erstellen

set.seed(crv$seed)
crs$rf <- randomForest(cat ~ .,
      data=crs$dataset[crs$sample,c(crs$input, crs$target)], 
      ntree=500,
      mtry=50,
      importance=TRUE,
      na.action=na.omit,
      replace=FALSE)

# Die Textausgabe des Modells 'Random Forest' erstellen

crs$rf

# Die Wicktigkeit der Variablen auflisten

rn <- round(importance(crs$rf), 2)
rn[order(rn[,3], decreasing=TRUE),]

# Benötigte Zeit: 16.97 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 00:55:21 x86_64-pc-linux-gnu 

# Random Forest 

# Das Paket 'party' stellt die Funktion 'cforest' zur Verfügung.

require(party, quietly=TRUE)

# Das Random Forest-Modell erstellen

set.seed(crv$seed)
crs$rf <- cforest(cat ~ .,
      data=na.omit(crs$dataset[crs$sample,c(crs$input, crs$target)]), controls=cforest_unbiased(
      ntree=300,
      mtry=50))

# Die Textausgabe des Modells 'Random Forest' erstellen

crs$rf

# Die Wicktigkeit der Variablen auflisten

vi <- as.data.frame(sort(varimp(crs$rf), decreasing=TRUE))
 names(vi) <- 'Importance'
vi

# Benötigte Zeit: 1.08 Min

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:16:25 x86_64-pc-linux-gnu 

# Support Vector Machine 

# Das Paket 'kernlab' stellt die Funktion 'ksvm' zur Verfügung.

require(kernlab, quietly=TRUE)

# Ein Support Vector Machine-Modell erstellen

set.seed(crv$seed)
crs$ksvm <- ksvm(as.factor(cat) ~ .,
      data=crs$dataset[crs$train,c(crs$input, crs$target)],
      kernel="rbfdot",
      prob.model=TRUE)

# Eine Textansicht des Modells SVM erstellen

crs$ksvm

# Benötigte Zeit: 8.78 Sek

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:16:56 x86_64-pc-linux-gnu 

# Regressionsmodell 

# Ein multinomiales Modell mit dem nnet-Paket erstellen

require(nnet, quietly=TRUE)

# Das multinomiale Modell anhand von Anova des Car-Pakets zusammenfassen

require(car, quietly=TRUE)

# Ein Regressionsmodell erstellen

crs$glm <- multinom(cat ~ ., data=crs$dataset[crs$train,c(crs$input, crs$target)], trace=FALSE, maxit=1000)

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:17:23 x86_64-pc-linux-gnu 

# Datenreihe auswerten 

# Wahrscheinlichkeitswertungen für das Modell Entscheidungsstruktur über data.t.csv [Valdieren] erhalten

crs$pr <- predict(crs$rpart, newdata=crs$dataset[crs$validate, c(crs$input)], type="class")

# Wahrscheinlichkeitswertungen für das Modell Random Forest über data.t.csv [Valdieren] erhalten

crs$pr <- predict(crs$rf, newdata=na.omit(crs$dataset[crs$validate, c(crs$input)]))

# Wahrscheinlichkeitswertungen für das Modell SVM über data.t.csv [Valdieren] erhalten

crs$pr <- predict(crs$ksvm, newdata=na.omit(crs$dataset[crs$validate, c(crs$input)]))

# Cluster-Anzahl für das Modell K-Means über data.t.csv [Valdieren] erhalten

crs$pr <- predict(crs$kmeans, crs$dataset[crs$validate, c(crs$input)])

# Die relevanten Variablen aus der Datenreihe extrahieren

sdata <- subset(crs$dataset[crs$validate,], select=c("word", "cat"))

# Die kombinierten Daten öffnen

write.csv(cbind(sdata, crs$pr), file="/home/mex/ballin-tyrion/R/dataset1/data_Valdieren_score_idents.csv", row.names=FALSE)

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:18:07 x86_64-pc-linux-gnu 

# Die Projektdaten (Variable crs) in die Datei speichern

save(crs, file="/home/mex/ballin-tyrion/R/dataset1/data.t.rattle", compress=TRUE)

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:18:38 x86_64-pc-linux-gnu 

# Hauptkomponenten-Analyse (nur für Zahlen)

pc <- prcomp(na.omit(crs$dataset[crs$sample, crs$numeric]), scale=TRUE, center=TRUE, tol=0)

# Die Ausgabe der Analyse zeigen

pc

# Die Wichtigkeit der gefunden Komponenten zusammenfassen

summary(pc)

# Einen Plot mit der relativen Wichtigkeit der Komponenten anzeigen

plot(pc, main="")
title(main="Hauptkomponenten-Wichtigkeit data.t.csv",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))
axis(1, at=seq(0.7, ncol(pc$rotation)*1.2, 1.2), labels=colnames(pc$rotation), lty=0)

# Einen Pot mit den beiden wichtigsten Komponenten anzeigen

biplot(pc, main="")
title(main="Hauptkomponenten data.t.csv",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:19:15 x86_64-pc-linux-gnu 

# Die Grafik in einer Datei speichern 

# Die Grafik auf dem Gerät 2 in einer Datei speichern

library(cairoDevice)
savePlotToFile("/home/mex/ballin-tyrion/R/dataset1/data.t_plot.pdf", 2)

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:19:22 x86_64-pc-linux-gnu 

# Hauptkomponenten-Analyse (nur für Zahlen)

pc <- prcomp(na.omit(crs$dataset[crs$sample, crs$numeric]), scale=TRUE, center=TRUE, tol=0)

# Die Ausgabe der Analyse zeigen

pc

# Die Wichtigkeit der gefunden Komponenten zusammenfassen

summary(pc)

# Einen Plot mit der relativen Wichtigkeit der Komponenten anzeigen

plot(pc, main="")
title(main="Hauptkomponenten-Wichtigkeit data.t.csv",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))
axis(1, at=seq(0.7, ncol(pc$rotation)*1.2, 1.2), labels=colnames(pc$rotation), lty=0)

# Einen Pot mit den beiden wichtigsten Komponenten anzeigen

biplot(pc, main="")
title(main="Hauptkomponenten data.t.csv",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

#============================================================
# Rattle Zeitstempel: 2013-11-29 01:19:42 x86_64-pc-linux-gnu 

# Die Grafik in einer Datei speichern 

# Die Grafik auf dem Gerät 3 in einer Datei speichern

library(cairoDevice)
savePlotToFile("/home/mex/ballin-tyrion/R/dataset1/data.t_plot_pca.pdf", 3)
