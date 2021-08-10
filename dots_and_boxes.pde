import java.util.*;

int size = 5;                                          //number of dots wide/tall the grid is
float scl = 500 / size;                                //used to determine distances and where to draw shapes
int selected_index = -1;                               //index of the selected dot
Polygon[] dots = createGrid();                         //array of dots
int[] lines = new int[4 * (size - 1) * size];          //list of created lines
int lines_index = 0;                                   //current index of the lines list
boolean player = false;                                //used to determine whose turn it is
boolean[] colors = new boolean[lines.length];          //list of line colors
int[] squares = new int[size * size];                  //list of created squares
int squares_index = 0;                                 //current index of the squares list
boolean[] square_colors = new boolean[squares.length]; //list of square colors
int red = 0;                                           //red's score
int blue = 0;                                          //blue's score

void setup() {
    size(500, 500);
    Arrays.fill(squares, -1);
}

void draw() {
    background(255);
    translate(scl / 2, scl / 2);
    stroke(0);
    fill(0);
    for (int i = 0; i < dots.length; i++) {

        //check if mouse is pressed and on a dot
        if (
            (dots[i].contains(mouseX - (scl / 2), mouseY - (scl / 2)) || selected_index == i) &&
            mousePressed
        ) {

            //check if the dot being hovered over is not the already selected dot and that the dot is orthogonally adjecent to the selected dot
            if (
                selected_index != i &&
                selected_index != -1 &&
                dist(dots[i].avgX(), dots[i].avgY(), dots[selected_index].avgX(), dots[selected_index].avgY()) <= scl
            ) {

                //check if the line wanting to be created already exists
                boolean contain = true;
                int minDot = min(i, selected_index);
                int maxDot = max(i, selected_index);
                for (int j = 0; j < lines_index; j += 2) {
                    if (lines[j] == minDot && lines[j + 1] == maxDot) {
                        contain = false;
                    }
                }
                if (contain) {
                    lines[lines_index] = minDot;
                    lines[lines_index + 1] = maxDot;
                    lines_index += 2;
                    selected_index = -1;
                    colors[(lines_index / 2) - 1] = player;
                    boolean foundSquare = false;

                    //check if a new square has been created by the new line
                    if (findSquare(minDot) && !squaresContain(minDot)) {
                        squares[squares_index] = minDot;
                        square_colors[squares_index++] = player;
                        foundSquare = true;
                        if (player) {
                            red++;
                        } else {
                            blue++;
                        }
                    }
                    if (maxDot - 1 == minDot) {
                        //line is horizontal
                        int k = minDot - size;
                        if (k >= 0 && findSquare(k) && !squaresContain(k)) {
                            squares[squares_index] = k;
                            square_colors[squares_index++] = player;
                            foundSquare = true;
                            if (player) {
                                red++;
                            } else {
                                blue++;
                            }
                        }
                    } else {
                        println("hello");
                        //line is vertical
                        int k = minDot - 1;
                        if (k >= 0 && k % size != 1 && findSquare(k) && !squaresContain(k)) {
                            squares[squares_index] = k;
                            square_colors[squares_index++] = player;
                            foundSquare = true;
                            if (player) {
                                red++;
                            } else {
                                blue++;
                            }
                        }
                    }

                    //if a square was created, update the score - otherwise change whose turn it is
                    if (foundSquare) {
                        println();
                        println();
                        println("Red: " + red + "  Blue: " + blue);
                    } else {
                        player = !player;
                    }
                }
            }
            dots[i].drawPolygon();
            selected_index = i;
        } else {
            dots[i].fillPolygon();
        }

        //deselect dot if mouse is not pressed
        if (!mousePressed) {
            selected_index = -1;
        }
    }

    //draw lines
    for (int i = 0; i < lines_index / 2; i++) {
        int index = i * 2;
        if (colors[i] == true) {
            stroke(255, 0, 0);
        } else {
            stroke(0, 0, 255);
        }
        line(dots[lines[index]].avgX(), dots[lines[index]].avgY(), dots[lines[index + 1]].avgX(), dots[lines[index + 1]].avgY());
        stroke(0);
    }

    //draw squares
    for (int i = 0; i < squares_index; i++) {
        if (square_colors[i]) {
            fill(255, 0, 0);
            stroke(255, 0, 0);
        } else {
            fill(0, 0, 255);
            stroke(0, 0, 255);
        }
        rect(dots[squares[i]].avgX(), dots[squares[i]].avgY(), scl, scl);
    }
}

Polygon[] createGrid() {
    Polygon[] dots = new Polygon[size * size];
    for (int i = 0; i < dots.length; i++) {
        dots[i] = new Polygon();
        dots[i].setMaxCorners(4);
        dots[i].addPoint(0, 0);
        dots[i].addPoint(10, 0);
        dots[i].addPoint(10, 10);
        dots[i].addPoint(0, 10);
    }
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            int dot_index = i * size + j;
            dots[dot_index].translateTo(j * scl, i * scl);
        }
    }
    return dots;
}

//checks for a square where the top left corner is dot[index]
boolean findSquare(int index) {
    int sides = 0;
    for (int i = 0; i < lines_index; i += 2) {
        if (lines[i] == index) {
            if (lines[i + 1] == index + 1) {
                sides += 1;
            }
            if (lines[i + 1] == index + size) {
                sides += 1;
            }
        }
        if (lines[i] == index + 1 && lines[i + 1] == index + size + 1) {
            sides += 1;
        }
        if (lines[i] == index + size && lines[i + 1] == index + size + 1) {
            sides += 1;
        }
    }
    return sides == 4;
}

boolean squaresContain(int item) {
    for (int i = 0; i < squares_index; i++) {
        if (squares[i] == item) {
            return true;
        }
    }
    return false;
}
