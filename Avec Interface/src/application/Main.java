package application;
	
import org.apache.log4j.Logger;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;


public class Main extends Application {
	
	private static Logger logger = Logger.getLogger(Main.class);
	
	private static Stage stage;
	
	@Override
	public void start(Stage primaryStage) {
		try {
			stage = primaryStage;
			stage.setTitle("Scrabble");
			
			Parent root = FXMLLoader.load(getClass().getClassLoader().getResource("views/Plateau.fxml"));
			
			Scene scene = new Scene(root);
			scene.getStylesheets().add(getClass().getResource("/views/game.css").toExternalForm());
			
			primaryStage.getIcons().add(new Image("Images/app_icon.jpg")); // Set app icon
			primaryStage.setResizable(false);
			primaryStage.setScene(scene);
			primaryStage.show();
			
			primaryStage.setOnCloseRequest(e -> Platform.exit());
			logger.info("Application start");
		} catch(Exception exception) {
			logger.error(exception.getMessage(), exception);
		}
	}
	
	public static void main(String[] args) {
		launch(args);
	}
	
	public static Stage getPrimaryStage() {
		return stage;
	}
}
