package game;

public class Solution {
	
	private String word;
	private Integer points;
	private Integer line;
	private Integer column;
	private String direction;
	
	public Solution(String word, Integer points, Integer line, Integer column, String direction) {
		this.word = word;
		this.points = points;
		this.line = line;
		this.column = column;
		this.direction = direction;
	}

	public Solution(String line) {
		String[] parts = line.replace('[', Character.MIN_VALUE).replace(']', Character.MIN_VALUE).replaceAll("'", "").split(",");
		this.word = parts[0].trim();
		this.points = Integer.parseInt(parts[4].trim());
		this.line = Integer.parseInt(parts[1].trim());
		this.column = Integer.parseInt(parts[2].trim());
		this.direction = Boolean.parseBoolean(parts[3].trim()) ? "Ligne" : "Colonne";
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public Integer getPoints() {
		return points;
	}

	public void setPoints(Integer points) {
		this.points = points;
	}

	public Integer getLine() {
		return line;
	}

	public void setLine(Integer line) {
		this.line = line;
	}

	public Integer getColumn() {
		return column;
	}

	public void setColumn(Integer column) {
		this.column = column;
	}

	public String getDirection() {
		return direction;
	}

	public void setDirection(String direction) {
		this.direction = direction;
	}
	
	

	@Override
	public String toString() {
		String str = "False";
		if ("Ligne".equals(direction)) {
			str = "True";
		}
		return ("[['" + word + "', "  + line + ", " + column + ", " + str + "], " + points + "]");
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((column == null) ? 0 : column.hashCode());
		result = prime * result + ((direction == null) ? 0 : direction.hashCode());
		result = prime * result + ((line == null) ? 0 : line.hashCode());
		result = prime * result + ((points == null) ? 0 : points.hashCode());
		result = prime * result + ((word == null) ? 0 : word.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		
		if (obj == null) {
			return false;
		}
		
		if (getClass() != obj.getClass()) {
			return false;
		}
		
		Solution other = (Solution) obj;
		return (other.getColumn()==this.column && other.getDirection().equals(this.direction) 
				&& other.getLine()==this.line && other.getWord().equals(this.word));
	}
}
