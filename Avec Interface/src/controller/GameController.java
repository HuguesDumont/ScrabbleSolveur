package controller;

import org.apache.log4j.Logger;

import game.Game;
import game.InitGame;
import game.Solution;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableRow;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.GridPane;

public class GameController {
	
	private static Logger logger = Logger.getLogger(GameController.class);
	
	private Game game;
	private ObservableList<Solution> possibilities  = FXCollections.observableArrayList();
	
	@FXML
	private Button endTurn;
	
	@FXML
	private Button exchange;
	
	@FXML
	private GridPane gameGrid;
	
	@FXML
	private GridPane drawPane;
	
	@FXML
	private TableView<Solution> solutions;

	@FXML
	private TableColumn<Solution, String> wordColumn;

	@FXML
	private TableColumn<Solution, Integer> pointsColumn;

	@FXML
	private TableColumn<Solution, Integer> lineColumn;
	
	@FXML
	private TableColumn<Solution, Integer> columnColumn;
	
	@FXML
	private TableColumn<Solution, String> directionColumn;
	
    @FXML
    private Label score;
	
	@FXML
	public void initialize() {
		wordColumn.setCellValueFactory(new PropertyValueFactory<>("word"));
		pointsColumn.setCellValueFactory(new PropertyValueFactory<>("points"));
		lineColumn.setCellValueFactory(new PropertyValueFactory<>("line"));
		columnColumn.setCellValueFactory(new PropertyValueFactory<>("column"));
		directionColumn.setCellValueFactory(new PropertyValueFactory<>("direction"));
		
		solutions.setRowFactory( tv -> {
			TableRow<Solution> row = new TableRow<>();
			row.setOnMouseClicked(event -> {
				if (event.getClickCount() == 2 && (! row.isEmpty()) ) {
					Solution solution = row.getItem();
					game.poser(solution);
				}
			});
			return row;
		});
		
		InitGame.initGrid(gameGrid);
		InitGame.initDraw(drawPane);
		
		logger.info("User interface loaded");
		game = new Game(this);
	}
	
	@FXML
	private void finishTurn(ActionEvent event) {
		game.endTurn();
	}
	
	@FXML
	private void change(ActionEvent event) {
		game.change();
	}

	public Button getEndTurn() {
		return endTurn;
	}

	public void setEndTurn(Button endTurn) {
		this.endTurn = endTurn;
	}

	public GridPane getGameGrid() {
		return gameGrid;
	}

	public void setGameGrid(GridPane gameGrid) {
		this.gameGrid = gameGrid;
	}

	public GridPane getDrawPane() {
		return drawPane;
	}

	public void setDrawPane(GridPane drawPane) {
		this.drawPane = drawPane;
	}

	public TableView<Solution> getSolutions() {
		return solutions;
	}

	public void setSolutions(TableView<Solution> solutions) {
		this.solutions = solutions;
	}

	public TableColumn<Solution, String> getWordColumn() {
		return wordColumn;
	}

	public void setWordColumn(TableColumn<Solution, String> wordColumn) {
		this.wordColumn = wordColumn;
	}

	public TableColumn<Solution, Integer> getPointsColumn() {
		return pointsColumn;
	}

	public void setPointsColumn(TableColumn<Solution, Integer> pointsColumn) {
		this.pointsColumn = pointsColumn;
	}

	public TableColumn<Solution, Integer> getLineColumn() {
		return lineColumn;
	}

	public void setLineColumn(TableColumn<Solution, Integer> lineColumn) {
		this.lineColumn = lineColumn;
	}

	public TableColumn<Solution, Integer> getColumnColumn() {
		return columnColumn;
	}

	public void setColumnColumn(TableColumn<Solution, Integer> columnColumn) {
		this.columnColumn = columnColumn;
	}

	public TableColumn<Solution, String> getDirectionColumn() {
		return directionColumn;
	}

	public void setDirectionColumn(TableColumn<Solution, String> directionColumn) {
		this.directionColumn = directionColumn;
	}

	public ObservableList<Solution> getPossibilities() {
		return possibilities;
	}

	public void setPossibilities(ObservableList<Solution> possibilities) {
		this.possibilities = possibilities;
	}

	public Button getExchange() {
		return exchange;
	}

	public void setExchange(Button exchange) {
		this.exchange = exchange;
	}

	public Label getScore() {
		return score;
	}

	public void setScore(Label score) {
		this.score = score;
	}
}
