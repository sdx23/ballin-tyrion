# Rattle is Copyright (c) 2006-2013 Togaware Pty Ltd.

#============================================================
# Rattle Zeitstempel: 2013-11-29 12:00:12 x86_64-pc-linux-gnu 

# Rattle Version 2.6.26 Benutzer 'mex'

# Exportieren Sie diese Log-Textansicht in eine Datei anhand des Buttons 
# Exportieren oder dem Tools-Menü, um ein Log über alle Aktivitäten zu speichern. Dies vereinfacht Wiederholungen. Exportieren 
# in die Datei 'myrf01.R' ermöglicht z. B., dass man in der R-Konsole den 
# Befehl source('myrf01.R') eingeben kann, um den Ablauf automatisch zu 
# wiederholen. Ggf. möchten wir die Datei für unsere Zwecke bearbeiten. Wir können diese aktuelle Textansicht auch direkt 
# bearbeiten, um zusätzliche Informationen aufzuzeichnen, bevor exportiert wird. 
 
# Beim Speichern und Laden von Projekten bleibt dieses Log ebenfalls erhalten.

library(rattle)

numberneurons <- 1
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
# Rattle Zeitstempel: 2013-11-29 12:08:27 x86_64-pc-linux-gnu 

# Die Daten laden

crs$dataset <- read.csv("file:///home/mex/ballin-tyrion/R/dataset1/data.t.csv", na.strings=c(".", "NA", "", "?"), strip.white=TRUE, encoding="UTF-8")

#============================================================
# Rattle Zeitstempel: 2013-11-29 12:08:37 x86_64-pc-linux-gnu 

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
# Rattle Zeitstempel: 2013-11-29 12:09:17 x86_64-pc-linux-gnu 

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
# Rattle Zeitstempel: 2013-11-29 12:09:30 x86_64-pc-linux-gnu 

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
# Rattle Zeitstempel: 2013-11-29 12:10:10 x86_64-pc-linux-gnu 

# Neural Network 

# Ein neurales Netzwerk mit dem nnet-Paket erstellen

require(nnet, quietly=TRUE)

# Build the NNet model.

set.seed(199)
crs$nnet <- nnet(cat ~ .,
    data=crs$dataset[crs$sample,c(crs$input, crs$target)],
    size=numberneurons, linout=TRUE, skip=TRUE, MaxNWts=10000, trace=FALSE, maxit=100)

# Die Ergebnisse des Modells ausdrucken

cat(sprintf("A %s network with %d weights.\n",
    paste(crs$nnet$n, collapse="-"),
    length(crs$nnet$wts)))
cat(sprintf("Inputs: %s.\n",
    paste(crs$nnet$coefnames, collapse=", ")))
cat(sprintf("Output: %s.\n",
    names(attr(crs$nnet$terms, "dataClasses"))[1]))
cat(sprintf("Sum of Squares Residuals: %.4f.\n",
    sum(residuals(crs$nnet) ^ 2)))
cat("\n")
print.summary.nnet.rattle(summary(crs$nnet))
cat('\n')

# Benötigte Zeit: 3.79 Min

#============================================================
# Rattle Zeitstempel: 2013-11-29 12:14:21 x86_64-pc-linux-gnu 

# Datenreihe auswerten 

# Prognosen für das Modell Neurales Netz über data.t.csv [Valdieren] erhalten

crs$pr <- predict(crs$nnet, newdata=crs$dataset[crs$validate, c(crs$input)])

# Die relevanten Variablen aus der Datenreihe extrahieren

sdata <- subset(crs$dataset[crs$validate,], select=c("word", "cat"))

# Die kombinierten Daten öffnen

write.csv(cbind(sdata, crs$pr), file=paste("/home/mex/ballin-tyrion/R/dataset1/nn",numberneurons,".csv"), row.names=FALSE)