package game;

import javafx.scene.layout.GridPane;
import utilities.LabelHandler;
import utilities.StyleCSS;

public class InitGame {

	/**
	 * Utility class for initializing a new Game (Grid, score, pick and rack)
	 */
	private InitGame() {}
	
	/**
	 * Creating game grid
	 */
	public static void initGrid(GridPane gameGrid) {
		for(int i = 0; i < 15; i++) {
			for(int j = 0; j < 15; j++) {
				String cssClass;
				if(Gameplay.isTripleWord(i, j)) {
					cssClass = StyleCSS.TW;
				} else if (Gameplay.isDoubleWord(i,j)) {
					cssClass = StyleCSS.DW;
				} else if (Gameplay.isTripleLetter(i,j)) {
					cssClass = StyleCSS.TL;
				} else if (Gameplay.isDoubleLetter(i,j)){
					cssClass = StyleCSS.DL;
				} else {
					cssClass = StyleCSS.EMPTY;
				}
				LabelHandler.addLabel(i, j, gameGrid, cssClass, LabelHandler.GRID_LABEL + i + "C" + j);		
			}
		}
	}
	
	/**
	 * Creating rack grid
	 */
	public static void initDraw(GridPane drawPane) {
		for(int i = 0; i<=6; i++) {
			LabelHandler.addLabel(0, i, drawPane, "full", LabelHandler.DRAW_LABEL + i);
		}
	}
}
