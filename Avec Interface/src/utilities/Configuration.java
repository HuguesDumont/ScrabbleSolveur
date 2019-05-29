package utilities;

import java.io.IOException;

import org.apache.log4j.Logger;
import org.json.JSONObject;

public class Configuration {
	public static final String CONFIG_PATH = "/src/resources/config.json";
	public static final String LETTERS_PATH = "/src/resources/letters/";
	public static final String PYTHON_PATH = "/src/resources/python/";
	
	private static Logger logger = Logger.getLogger(Configuration.class);
	
	/**
	 * Utility class for methods about configuration
	 */
	private Configuration() {}
	
	/**
	 * Get current language
	 * @return the current language
	 */
	public static String getLanguage() {
		try {
			JSONObject object = new JSONObject(FileHandling.readFile(CONFIG_PATH, null));
			return object.getString("language");
		} catch (IOException exception) {
			logger.error(exception.getMessage(), exception);
			return null;
		}
	}
	
	/**
	 * Get path of letters file corresponding to current language
	 * @return path of letters file
	 */
	public static String getLettersPath() {
		return FileHandling.getFullPath(LETTERS_PATH + getLanguage() + ".txt");
	}
}
