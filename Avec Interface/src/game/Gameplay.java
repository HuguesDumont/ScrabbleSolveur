package game;

import java.util.HashMap;

import javafx.scene.layout.GridPane;
import utilities.LabelHandler;

public class Gameplay {

	/**
	 * Utility class for game mechanics
	 */
	private Gameplay() {}

	/**
	 * Check if case if triple word or not
	 * @param i row
	 * @param j column
	 * @return true if is triple word case else return false
	 */
	public static boolean isTripleWord(int i, int j) {
		return ((i%7==0) && (j%14==0)) || ((i%14==0) && j==7);
	}
	
	/**
	 * Check if case if double word or not
	 * @param i row
	 * @param j column
	 * @return true if is double word case else return false
	 */
	public static boolean isDoubleWord(int i, int j) {
		return (i==j && i>0 && i<14 && (i<5 || i > 9 || i==7)) ||
				(i+j==14 && ((i>0 && i<5) || (j>0 && j<5)));
	}
	
	/**
	 * Check if case if triple letter or not
	 * @param i row
	 * @param j column
	 * @return true if is triple letter case else return false
	 */
	public static boolean isTripleLetter(int i, int j) {
		return ((j==5 || j==9) && (i==1 || i==5 || i==9 || i ==13)) ||
			((i== 5 || i ==9) && (j==1 || j == 13));
	}
	
	/**
	 * Check if case if double letter or not
	 * @param i row
	 * @param j column
	 * @return true if is double letter case else return false
	 */
	public static boolean isDoubleLetter(int i, int j) {
		return ((i%7==0) && (j==3 || j==11)) || 
				((i==2 || i==6 || i==8 ||i==12) && (j==6 || j==8)) ||
				((i==3 || i==11) && (j%7==0)) ||
				((i==6 || i==8) && (j==2 || j==12));
	}

	public static int scoreCrossWord(GridPane gameGrid, int line, int column, boolean col, HashMap<String, Integer> letterValues) {
		int score = 0;
		String labelId;
		
		if(col) { // mot posé en colonne
			int i = (column - 1);
			while(i>=0) {
				labelId = LabelHandler.GRID_LABEL + line + "C" + i;
				if(LabelHandler.isEmpty(gameGrid, labelId)) {
					break;
				}
				score += letterValues.get(LabelHandler.getLabelLetter(gameGrid, labelId));
				i--;
			}
			i = column+1;
			while(i < 15) {
				labelId = LabelHandler.GRID_LABEL + line + "C" + i;
				if(LabelHandler.isEmpty(gameGrid, labelId)) {
					break;
				}
				score += letterValues.get(LabelHandler.getLabelLetter(gameGrid, labelId));
				i++;
			}
		} else {
			int i = (line - 1);
			while(i>=0) {
				labelId = LabelHandler.GRID_LABEL + i + "C" + column;
				if(LabelHandler.isEmpty(gameGrid, labelId)) {
					break;
				}
				score += letterValues.get(LabelHandler.getLabelLetter(gameGrid, labelId));
				i--;
			}
			i = line+1;
			while(i < 15) {
				labelId = LabelHandler.GRID_LABEL + i + "C" + column;
				if(LabelHandler.isEmpty(gameGrid, labelId)) {
					break;
				}
				score += letterValues.get(LabelHandler.getLabelLetter(gameGrid, labelId));
				i++;
			}
		}
		return score;
	}
}
