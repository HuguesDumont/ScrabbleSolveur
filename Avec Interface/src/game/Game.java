package game;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;

import controller.GameController;
import javafx.scene.control.Label;
import utilities.Configuration;
import utilities.FileHandling;
import utilities.LabelHandler;

public class Game {
	
	private static Logger logger = Logger.getLogger(Game.class);
	
	private HashMap<String, Integer> letterValues;
	
	//Handling current solution
	private Solution lastSolution;
	private ArrayList<Label> fromDraw;
	private ArrayList<Label> fromGrid;
	
	//Process for python execution
	private ProcessBuilder pb;
	private Process p;
	private BufferedReader reader;
	private BufferedWriter writer;
	
	GameController gameScreen;
	
	public Game(GameController gameController) {
		gameScreen = gameController;
		newGame();
		logger.info("New game started");
	}
	
	/**
	 * Create a new game with x players
	 * @param x number of players
	 */
	private void newGame() {
		// Initializing
		fromDraw = new ArrayList<>();
		fromGrid = new ArrayList<>();
		lastSolution = null;
		letterValues = new HashMap<>();
		
		for(String line : FileHandling.getLines(Configuration.getLettersPath())) {
			String[] letterInfos = line.split(" ");
			// Creating the pick (adding the correct number of each letter)
			for(int i = 0; i<Integer.parseInt(letterInfos[2]);i++) {
				letterValues.put(letterInfos[0], Integer.valueOf(letterInfos[1]));
			}
		}
		
		try {
			//exec process
			pb = new ProcessBuilder("python",FileHandling.getFullPath(Configuration.PYTHON_PATH + "main.py")); //command
			pb.redirectErrorStream(true);
			pb.redirectOutput(ProcessBuilder.Redirect.PIPE); // ProcessBuildeR.Redirect.INHERIT
			p = pb.start();
			
			//init input/output communication with process
			reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
			writer = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
			
			//read from process
			readFromPython();
			
		} catch(Exception exception) {
			logger.error(exception.getMessage(), exception);
		}
	}
	
	/**
	 * Ending current turn :
	 * 		Check if letters put on grid are on a correct position
	 * 		Check if made words are valid
	 * 		Update the score
	 * 		Draw new letters if needed
	 */
	public void endTurn() {
		gameScreen.getScore().setText(String.valueOf(Integer.valueOf(gameScreen.getScore().getText()) + lastSolution.getPoints()));
		
		int line = lastSolution.getLine();
		int column = lastSolution.getColumn();
	
		if(LabelHandler.COLUMN.equals(lastSolution.getDirection())) {
			for(int i = 0; i < lastSolution.getWord().length(); i++) {
				LabelHandler.changeLabelClass(gameScreen.getGameGrid(),  (line + i), column);
			}
		} else {
			for(int i = 0; i < lastSolution.getWord().length(); i++) {
				LabelHandler.changeLabelClass(gameScreen.getGameGrid(), line, (column + i));
			}
		}
		
		//write to process
		try {
			writer.write(lastSolution.toString() + "\n");
			writer.flush();
			readFromPython();
			
			logger.info("Writting to Python process");
		} catch (Exception exception) {
			logger.error(exception.getMessage(), exception);
		}
		
		lastSolution = null;
		fromGrid.clear();
		fromDraw.clear();
	}

	/**
	 * Change the draw
	 */
	public void change() {
		try {
			writer.write("!\n");
			writer.flush();
			
			logger.info("Writting to Python process");
			
			readFromPython();
		} catch (Exception exception) {
			logger.error(exception.getMessage(), exception);
		}
		
		lastSolution = null;
		fromGrid.clear();
		fromDraw.clear();
	}

	/**
	 * Put the selected solution on grid
	 * @param solution the chosen solution
	 */
	public void poser(Solution solution) {
		if(lastSolution == null) {
			int line = solution.getLine();
			int column = solution.getColumn();
		
			if(LabelHandler.COLUMN.equals(solution.getDirection())) {
				for(int i = 0; i < solution.getWord().length(); i++) {
					changeSolution(solution, LabelHandler.formatGridLabel(line+i, column), i);
				}
			} else {
				for(int i = 0; i < solution.getWord().length(); i++) {
					changeSolution(solution, LabelHandler.formatGridLabel(line, column+i), i);
				}
			}
		} else if (!lastSolution.equals(solution)) {
			
			for(int i = fromGrid.size()-1; i>=0; i--) {
				Label gridLab = fromGrid.remove(i);
				LabelHandler.changeLabelLetter(gameScreen.getDrawPane(), fromDraw.remove(i).getId(), gridLab.getText());
				LabelHandler.changeLabelLetter(gameScreen.getGameGrid(), gridLab.getId(), "");
			}
			
			int line = solution.getLine();
			int column = solution.getColumn();
		
			if(LabelHandler.COLUMN.equals(solution.getDirection())) {
				for(int i = 0; i < solution.getWord().length(); i++) {
					changeSolution(solution, LabelHandler.formatGridLabel(line+i, column), i);
				}
			} else {
				for(int i = 0; i < solution.getWord().length(); i++) {
					changeSolution(solution, LabelHandler.formatGridLabel(line, column+i), i);
				}
			}
		}
		lastSolution = solution;
	}
	
	/**
	 * Update solution on grid
	 * @param id
	 */
	private void changeSolution(Solution solution, String id, int i) {
		if(LabelHandler.isEmpty(gameScreen.getGameGrid(), id)) {
			String letter =  solution.getWord().substring(i, i+1);
			LabelHandler.changeLabelLetter(gameScreen.getGameGrid(), id, letter);
			fromGrid.add(LabelHandler.getLabel(gameScreen.getGameGrid(), id));
			fromDraw.add(LabelHandler.removeFirst(gameScreen.getDrawPane(), letter));
		}
	}
	
	/**
	 * Read output from Python process
	 * @throws IOException 
	 * @throws InterruptedException 
	 */
	private boolean readFromPython() {
		//handle output
		boolean endReading = false;
		String line = null;
		int i = 0;
		// Clear list of possibilities
		gameScreen.getPossibilities().clear();
		try {
			while ((line = reader.readLine()) != null) {
				// If it's a letter, add it to the draw
				if(line.matches("[A-Z]")) {
					LabelHandler.changeLabelLetter(gameScreen.getDrawPane(), LabelHandler.DRAW_LABEL + i, line);
					i++;
				// If starts with "[" then it's a possible solution
				} else if (line.startsWith("[")) {
					Solution sol = new Solution(line);
					sol.setPoints(calculScore(sol));
					if(!gameScreen.getPossibilities().contains(sol) && sol.getPoints()>0 ) {
						gameScreen.getPossibilities().add(sol); // Add the solution to the list
					}
				// If line = "#" then end of the game (no more letters in pick and no more words possible to put on grid
				} else if ("#".equals(line)) {
					System.out.println("Game end");
				// If line = "*" then end of receiving solutions
				} else if ("*".equals(line)){
					endReading = true;
					break;
				} else {
					logger.info("Message received from Python process : " + line);
				}
			}
			gameScreen.getPossibilities().sort((a, b) -> Integer.compare(b.getPoints(), a.getPoints()));
			gameScreen.getSolutions().setItems(gameScreen.getPossibilities()); // Update the list
			
			logger.info("Finished read from Python process");
		} catch (IOException exception) {
			logger.error(exception.getMessage(), exception);
		}
		return endReading;
	}
	
	/**
	 * Calculates the score of a given solution
	 * @param sol the solution to calculate the score
	 * @return the score of the solution
	 */
	private int calculScore(Solution sol) {
		int line = sol.getLine();
		int column = sol.getColumn();
		int countFromDraw = 0;
		int scoreLetter = 0;
		int crossWord;
		int scoreWord = 0;
		int fullScore = 0;
		int bonusWord = 1;
		int bonus = 0;
		
		if(LabelHandler.COLUMN.equals(sol.getDirection())) {
			for(int i = 0; i < sol.getWord().length(); i++) {
				bonus = LabelHandler.getBonusLetter(gameScreen.getGameGrid(), (line+i), column);
				scoreLetter = letterValues.get(sol.getWord().substring(i, i+1));
				
				if(bonus < 0) {
					bonus = Math.abs(bonus);
					bonusWord *= bonus;
				} else {
					scoreLetter *= bonus;
					bonus = 1;
				}
				
				crossWord = 0;
				if(!LabelHandler.isUsed(gameScreen.getGameGrid(), LabelHandler.formatGridLabel(line+i, column))) {
					crossWord = Gameplay.scoreCrossWord(gameScreen.getGameGrid(), line+i, column, true, letterValues);
					if(crossWord!=0) {
						crossWord = (crossWord + scoreLetter)*bonus;
					} else {
						crossWord = 0;
					}
					countFromDraw++;
				}
				scoreWord += scoreLetter;
				fullScore += crossWord;
			}
			fullScore += (scoreWord*bonusWord);
		} else {
			for(int i = 0; i < sol.getWord().length(); i++) {
				bonus = LabelHandler.getBonusLetter(gameScreen.getGameGrid(), line, (column+i));
				scoreLetter = letterValues.get(sol.getWord().substring(i, i+1));
				
				if(bonus < 0) {
					bonus = Math.abs(bonus);
					bonusWord *= bonus;
				} else {
					scoreLetter *= bonus;
					bonus = 1;
				}
				
				crossWord = 0;
				if(!LabelHandler.isUsed(gameScreen.getGameGrid(), LabelHandler.formatGridLabel(line, column+i))) {
					crossWord = Gameplay.scoreCrossWord(gameScreen.getGameGrid(), line, column+i, false, letterValues);
					if(crossWord!=0) {
						crossWord = (crossWord + scoreLetter)*bonus;
					} else {
						crossWord = 0;
					}
					countFromDraw++;
				}
				scoreWord += scoreLetter;
				fullScore += crossWord;
			}
			fullScore += (scoreWord*bonusWord);
		}
		
		if(countFromDraw>7) {
			logger.error("More than 7 letters put on grid with solution : " + sol.getWord());
			return -1;
		}
		
		if(countFromDraw == 7) {
			fullScore += 50;
		}
		
		return fullScore;
	}
}
