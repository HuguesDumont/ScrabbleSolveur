package utilities;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.apache.log4j.Logger;

public class FileHandling {
	
	private static Logger logger = Logger.getLogger(FileHandling.class);
	
	/**
	 * Utility class for methods about file use
	 */
	private FileHandling() {}
	
	/**
	 * Read a file into a String
	 * @param path file path
	 * @param encoding file encoding
	 * @return a string with the whole file content
	 * @throws IOException
	 */
	public static String readFile(String path, Charset encoding) throws IOException {
		byte[] encoded = Files.readAllBytes(Paths.get(getFullPath(path)));
		if(encoding == null) {
			encoding = StandardCharsets.UTF_8;
		}
		return new String(encoded, encoding);
	}
	
	/**
	 * Read file line by line
	 * @param filename the file to read the line
	 * @return list of file lines
	 */
	public static List<String> getLines(String filename) {
		ArrayList<String> lines = new ArrayList<>();
		try (Scanner scanner = new Scanner(new FileReader(filename)))
		{
			while (scanner.hasNext()) {
				lines.add(scanner.nextLine());
			}
			logger.info("File processed without problem");
		} catch (IOException exception) {
			logger.error(exception.getMessage(), exception);
		}
		
		return lines;
	}
	
	/**
	 * Get full path of resource file
	 * @param filename
	 * @return the full path of file
	 */
	public static String getFullPath(String filename) {
		try {
			String str = (new File(".").getCanonicalPath()).replaceAll("\\\\", "/");
			return (str + filename);
		} catch (IOException exception) {
			logger.error(exception.getMessage(), exception);
			return "";
		}
	}
}
