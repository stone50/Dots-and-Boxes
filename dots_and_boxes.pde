import java.util.*;

void setup() {
  size(500, 500);
}

int size = 5;
float scl = 500/size;
int selected_index = -1;
Polygon[] dots = createGrid();
int[] lines = new int[4*(size-1)*size];
int lines_index = 0;
boolean contain = true;
boolean player = false;
boolean[] colors = new boolean[lines.length];
int[] squares = new int[size*size];
int squares_index = 0;
boolean[] square_colors = new boolean[squares.length];
boolean newSquares = true;
boolean foundSquare = false;
int red = 0;
int blue = 0;

void draw() {
  if (newSquares) {
    squares = createSquares(squares.length);
    newSquares = false;
  }
  background(255);
  translate(scl/2, scl/2);
  stroke(0);
  fill(0);
  for (int i = 0; i < dots.length; i++) {
    if ((dots[i].contains(mouseX-(scl/2), mouseY-(scl/2)) || selected_index == i) && mousePressed) {
      if (selected_index != i && selected_index != -1 && dist(dots[i].avgX(), dots[i].avgY(), dots[selected_index].avgX(), dots[selected_index].avgY()) <= scl) {
        for (int j = 0; j < lines.length-1; j++) {
          if (j%2 == 0 && lines[j] == min(i, selected_index) && lines[j+1] == max(i, selected_index)) {
            contain = false;
          }
        }
        if (contain == true) {
          lines[lines_index] = min(i, selected_index);
          lines[lines_index+1] = max(i, selected_index);
          lines_index += 2;
          selected_index = -1;
          colors[(lines_index/2)-1] = player;
          for (int k = 0; k < dots.length; k++) {
            if (findSquare(k) && !contains(squares, k)) {
              squares[squares_index] = k;
              square_colors[squares_index] = player;
              squares_index += 1;
              foundSquare = true;
              if (!player) {
                blue += 1;
              } else {
                red += 1;
              }
            }
          }
          if (!foundSquare) {
            player = !player;
          } else {
            foundSquare = false;
            println();
            println();
            println("Red: " + red + "  Blue: " + blue);
          }
        }
        contain = true;
      }
      dots[i].drawPolygon();
      selected_index = i;
    } else {
      dots[i].fillPolygon();
    }
    if (!mousePressed) {
      selected_index = -1;
    }
  }
  for (int i = 0; i < lines_index/2; i++) {
    int index = i*2;
    if (colors[i] == true) {
      stroke(255, 0, 0);
    } else {
      stroke(0, 0, 255);
    }
    line(dots[lines[index]].avgX(), dots[lines[index]].avgY(), dots[lines[index+1]].avgX(), dots[lines[index+1]].avgY());
    stroke(0);
  }
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
  Polygon[] dots = new Polygon[size*size];
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
      int dot_index = i*size+j;
      dots[dot_index].translateTo(j*scl, i*scl);
    }
  }
  return dots;
}

boolean findSquare(int index) {
  int sides = 0;
  for (int i = 0; i < lines.length-1; i++) {
    if (i%2 == 0) {
      if (lines[i] == index) {
        if (lines[i+1] == index+1) {
          sides += 1;
        }
        if (lines[i+1] == index+size) {
          sides += 1;
        }
      }
      if (lines[i] == index+1 && lines[i+1] == index+size+1) {
        sides += 1;
      }
      if (lines[i] == index+size && lines[i+1] == index+size+1) {
        sides += 1;
      }
    }
  }
  if (sides == 4) {
    return true;
  } else {
    return false;
  }
}

boolean contains(int[] list, int item) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == item) {
      return true;
    }
  }
  return false;
}

int[] createSquares(int len) {
  int[] list = new int[len];
  for (int i = 0; i < len; i++) {
    list[i] = -1;
  }
  return list;
}