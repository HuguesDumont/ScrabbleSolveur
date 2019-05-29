package utilities;

import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;

public class LabelHandler {
	
	public static final String LINE = "Ligne";
	public static final String COLUMN = "Colonne";
	public static final String GRID_LABEL = "caseR";
	public static final String DRAW_LABEL = "draw";
	
	/**
	 * At creation, initialize new turn
	 */
	private LabelHandler() {}
	
	/**
	 * Change label letter in gridPane
	 * @param gridPane the gridPane where the label resides
	 * @param id the label id
	 * @param value the new text of label
	 */
	public static void changeLabelLetter(GridPane gridPane, String id, String value) {
		Label label = (Label) gridPane.lookup("#" + id);	// Get the label by its id
		label.setText(value);								// Change its value
	}
	
	/**
	 * Get the text from a specified label
	 * @param gridPane the gridPane where the label resides
	 * @param id the label id
	 * @return the text inside the label
	 */
	public static String getLabelLetter(GridPane gridPane, String id) {
		return getLabel(gridPane, id).getText();
	}
	
	/**
	 * Return true if label is empty
	 * @param gridPane the gridPane where the label resides
	 * @param id the label id
	 * @return the text inside the label
	 */
	public static boolean isEmpty(GridPane gridPane, String id) {
		return getLabelLetter(gridPane, id).isEmpty();
	}
	
	/**
	 * Return true if label is already used on grid
	 * @param gridPane the gridPane where the label resides
	 * @param id the label id
	 * @return the text inside the label
	 */
	public static boolean isUsed(GridPane gridPane, String id) {
		return getLabel(gridPane, id).getStyleClass().contains(StyleCSS.FULL);
	}

	/**
	 * Adding label to gridPane
	 * @param posX the line to add the label
	 * @param posY the column to add the label
	 * @param gridPane the gridPane where the label will reside
	 * @param cssClass the CSS style of the label
	 * @param id the id of the label
	 */
	public static void addLabel(int posX, int posY, GridPane gridPane, String cssClass, String id) {
		Label label = new Label();							// Creating a new Label
		label.getStyleClass().clear();
		label.getStyleClass().add(cssClass);				// Adding CSS to label
		label.setId(id);									// Defining its id
		gridPane.add(label, posY, posX);					// Positioning the label on the gridPane
	}
	
	public static Label getLabel(GridPane gridPane, String id) {
		return (Label) gridPane.lookup("#" + id);
	}

	/**
	 * Remove first occurrence of given letter from draw
	 * @param letter the letter to remove
	 */
	public static Label removeFirst(GridPane drawPane, String letter) {
		for(int i = 0; i < 7 ; i++) {
			if(letter.equals(getLabelLetter(drawPane, LabelHandler.DRAW_LABEL + i))) {
				changeLabelLetter(drawPane, LabelHandler.DRAW_LABEL + i, "");
				return getLabel(drawPane, LabelHandler.DRAW_LABEL + i);
			}
		}
		return null;
	}
	
	/**
	 * Get the value of a letter
	 * @param GridPane the grid where to look for the label
	 * @param line the line on which the letter is located
	 * @param column the column on which the letter is located
	 * @return the value of the letter on grid
	 */
	public static int getBonusLetter(GridPane gridPane, int line, int column) {
		Label label = (Label) gridPane.lookup("#" + LabelHandler.GRID_LABEL + line + "C" + column);
		if(label.getStyleClass().contains(StyleCSS.EMPTY) || label.getStyleClass().contains(StyleCSS.FULL)) {
			return 1;
		}
		if(label.getStyleClass().contains(StyleCSS.TL)) {
			return 3;
		}
		if(label.getStyleClass().contains(StyleCSS.DL)) {
			return 2;
		}
		if(label.getStyleClass().contains(StyleCSS.TW)) {
			return -3;
		}
		if(label.getStyleClass().contains(StyleCSS.DW)) {
			return -2;
		}
		return 1;
	}

	/**
	 * Update label css on grid as it has a letter now
	 * @param gameGrid the gridPane of the grid
	 * @param line line of the label
	 * @param column column of the label
	 */
	public static void changeLabelClass(GridPane gameGrid, int line, int column) {
		Label label = (Label) gameGrid.lookup("#" + LabelHandler.formatGridLabel(line, column));
		label.getStyleClass().clear();
		label.getStyleClass().add(StyleCSS.FULL);
	}
	
	/**
	 * format id of grid label using its line and column
	 * @param line line of the label
	 * @param column column of the label
	 * @return
	 */
	public static String formatGridLabel(int line, int column) {
		return (LabelHandler.GRID_LABEL + line + "C" + column);
	}
}
