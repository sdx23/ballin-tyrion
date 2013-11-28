package is.hi.sdm.gutenberg;

import java.util.HashSet;
import java.util.Set;

public class StopWords {
	private static final Set<String> STOP_WORDS = new HashSet<String>();
	
	static {
		//Some stop words, allegedly from Google
		STOP_WORDS.add("i"); STOP_WORDS.add("a");
		STOP_WORDS.add("about"); STOP_WORDS.add("an");
		STOP_WORDS.add("are"); STOP_WORDS.add("as");
		STOP_WORDS.add("at"); STOP_WORDS.add("be");
		STOP_WORDS.add("by"); STOP_WORDS.add("com");
		STOP_WORDS.add("de"); STOP_WORDS.add("en");
		STOP_WORDS.add("for"); STOP_WORDS.add("from");
		STOP_WORDS.add("how"); STOP_WORDS.add("in");
		STOP_WORDS.add("is"); STOP_WORDS.add("it");
		STOP_WORDS.add("la"); STOP_WORDS.add("of");
		STOP_WORDS.add("on"); STOP_WORDS.add("or");
		STOP_WORDS.add("that"); STOP_WORDS.add("the");
		STOP_WORDS.add("this"); STOP_WORDS.add("to");
		STOP_WORDS.add("was"); STOP_WORDS.add("what");
		STOP_WORDS.add("when"); STOP_WORDS.add("where");
		STOP_WORDS.add("who"); STOP_WORDS.add("will");
		STOP_WORDS.add("with"); STOP_WORDS.add("and");
		STOP_WORDS.add("the"); STOP_WORDS.add("www");
	}
	
	public static boolean contains(String word) {
		return STOP_WORDS.contains(word);
	}
}
