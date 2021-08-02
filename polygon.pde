//this Polygon class extends the functionality of the built-in shape functions
//stroke is required to view the polygon
//be sure to set maxCorners to avoid syntax issues

//Guide:
//Function Name (a-z)        Line#

//addPoint()-----------------72
//avgX()---------------------310
//avgY()---------------------322
//contains()-----------------118
//drawPolygon()--------------36
//fillPolygon()--------------47
//intersectsPolygon()--------250
//reset()--------------------98
//resizePolygon()------------277
//rotatePolygon()------------200, 225
//setMaxCorners()------------109
//translatePolygon()---------189
//translateTo()--------------242
//XPoints()------------------82
//YPoints()------------------90


import java.util.*;
class Polygon {

  public int maxCorners = 10;
  public float[] xcoords = new float[this.maxCorners];
  public float[] ycoords = new float[this.maxCorners];
  public int index = 0;
  //=====================================================================================

  //draws outline of a polygon

  void drawPolygon() {
    for (int i = 0; i < this.index-1; i++) {
      line(this.xcoords[i], this.ycoords[i], this.xcoords[i+1], this.ycoords[i+1]);
    }
    line(this.xcoords[0], this.ycoords[0], this.xcoords[this.index-1], this.ycoords[this.index-1]);
  }

  //===================================================================================== 

  //draws a filled in polygon

  void fillPolygon() {
    drawPolygon();
    float minX = this.xcoords[0];
    float maxX = this.xcoords[0];
    float minY = this.ycoords[0];
    float maxY = this.ycoords[0];
    for (int i = 0; i < this.xcoords.length; i++) {
      minX = Math.round(Math.min(minX, this.xcoords[i]));
      maxX = Math.round(Math.max(maxX, this.xcoords[i]));
      minY = Math.round(Math.min(minY, this.ycoords[i]));
      maxY = Math.round(Math.max(maxY, this.ycoords[i]));
    }
    for (int y = (int)minY; y < maxY; y++) {
      for (int x = (int)minX; x < maxX; x++) {
        if (this.contains(x, y)) {
          point(x, y);
        }
      }
    }
  }

  //=====================================================================================

  //adds a corner to the polygon

  void addPoint(float x, float y) {
    this.xcoords[this.index] = x;
    this.ycoords[this.index] = y;
    this.index += 1;
  }

  //===================================================================================== 

  //returns list of all x coordinates that have been added

  float[] XPoints() {
    return Arrays.copyOfRange(this.xcoords, 0, this.index);
  }

  //=====================================================================================

  //returns list of all y coordinates that have been added

  float[] YPoints() {
    return Arrays.copyOfRange(this.ycoords, 0, this.index);
  }

  //=====================================================================================

  //resets the lists of coordinates

  void reset() {
    this.xcoords = new float[this.maxCorners];
    this.ycoords = new float[this.maxCorners];
    this.index = 0;
  }

  //=====================================================================================

  //sets the maximum number of corners
  //note: setMaxCorners will reset the lists of coordinates

  void setMaxCorners(int num) {
    this.maxCorners = num;
    this.reset();
  }

  //=====================================================================================

  //if the given coordinate is inside the polygon, it returns true, otherwise it returns false

  boolean contains(float x, float y) {
    float slope = 0;
    float b = 0;
    int right = 0;
    int intersections = 0;
    int lastRight = 0;
    for (int i = 0; i < this.index-1; i++) {
      if (this.ycoords[i] >= y || this.ycoords[i+1] >= y) {
        if (((this.xcoords[i] <= x && this.xcoords[i+1] > x) || (this.xcoords[i] >= x && this.xcoords[i+1] < x) || (this.xcoords[i] < x && this.xcoords[i+1] >= x) || (this.xcoords[i] > x && this.xcoords[i+1] <= x)) && ((this.xcoords[i] >= x && this.xcoords[i+1] < x) || (this.xcoords[i] <= x && this.xcoords[i+1] > x)) || (this.xcoords[i] > x && this.xcoords[i+1] <= x) || (this.xcoords[i] < x && this.xcoords[i+1] >= x)) {
          slope = (this.ycoords[i+1]-this.ycoords[i])/(this.xcoords[i+1]-this.xcoords[i]);
          b = this.ycoords[i]-(slope*this.xcoords[i]);
          if ((x*slope)+b >= y) {
            if (this.xcoords[i] == x && this.xcoords[i] > x && this.xcoords[i+1] != x) {
              right = int(this.xcoords[i+1]-x/abs(this.xcoords[i+1]-x));
              if (lastRight != right && lastRight != 0) {
                intersections ++;
              } else {
                intersections += 2;
              }
              lastRight = right;
            } else if (this.xcoords[i+1] == x && this.xcoords[i+1] > x && this.xcoords[i] != x) {
              right = int(this.xcoords[i]-x/abs(this.xcoords[i]-x));
              if (lastRight != right && lastRight != 0) {
                intersections ++;
              } else {
                intersections += 2;
              }
              lastRight = right;
            } else {
              intersections ++;
            }
          }
        }
      }
    }
    if (this.ycoords[this.index-1] >= y || this.ycoords[0] >= y) {
      if (((this.xcoords[this.index-1] <= x && this.xcoords[0] > x) || (this.xcoords[this.index-1] >= x && this.xcoords[0] < x)) && ((this.xcoords[this.index-1] >= x && this.xcoords[0] < x) || (this.xcoords[this.index-1] <= x && this.xcoords[0] > x))) {
        slope = (this.ycoords[0]-this.ycoords[this.index-1])/(this.xcoords[0]-this.xcoords[this.index-1]);
        b = this.ycoords[this.index-1]-(slope*this.xcoords[this.index-1]);
        if ((x*slope)+b >= y) {
          if (this.xcoords[this.index-1] == x && this.xcoords[this.index-1] > x && this.xcoords[0] != x) {
            right = int(this.xcoords[0]-x/abs(this.xcoords[0]-x));
            if (lastRight != right && lastRight != 0) {
              intersections ++;
            } else {
              intersections += 2;
            }
          } else if (this.xcoords[0] == x && this.xcoords[0] > x && this.xcoords[this.index-1] != x) {
            right = int(this.xcoords[this.index-1]-x/abs(this.xcoords[this.index-1]-x));
            if (lastRight != right && lastRight != 0) {
              intersections ++;
            } else {
              intersections += 2;
            }
          } else {
            intersections ++;
          }
        }
      }
    }
    if (intersections%2 == 0) {
      return false;
    } else {
      return true;
    }
  }

  //=====================================================================================

  //translates the polygon by the given x and y

  void translatePolygon(float x, float y) {
    for (int i = 0; i < index; i++) {
      this.xcoords[i] = this.xcoords[i] + x;
      this.ycoords[i] = this.ycoords[i] + y;
    }
  }

  //=====================================================================================

  //rotates the polygon by the given angle (in degrees) around an average coordinate

  void rotatePolygon(float angle) {
    float x1 = 0;
    float y1 = 0;
    for (int i = 0; i < this.index; i++) {
      x1 += this.xcoords[i];
      y1 += this.ycoords[i];
    }
    x1 = x1/this.index;
    y1 = y1/this.index;
    this.translatePolygon(-x1, -y1);
    for (int i = 0; i < this.index; i++) {
      float y2 = this.ycoords[i];
      float x2 = this.xcoords[i];
      float x3 = x2*cos(radians(angle))+y2*sin(radians(angle));
      float y3 = y2*cos(radians(angle))-x2*sin(radians(angle));
      this.xcoords[i] = x3;
      this.ycoords[i] = y3;
    }
    this.translatePolygon(x1, y1);
  }

  //======================================================================================

  //rotates the polygon by the given angle (in degrees) around a given coordinate

  void rotatePolygon(float x, float y, float angle) {
    this.translatePolygon(-x, -y);
    for (int i = 0; i < this.index; i++) {
      float y2 = this.ycoords[i];
      float x2 = this.xcoords[i];
      float x3 = x2*cos(radians(angle))+y2*sin(radians(angle));
      float y3 = y2*cos(radians(angle))-x2*sin(radians(angle));
      this.xcoords[i] = x3;
      this.ycoords[i] = y3;
    }
    this.translatePolygon(x, y);
  }

  //======================================================================================

  //translates the polygon to the given coordinate

  void translateTo(float x, float y) {
    this.translatePolygon(x-this.avgX(), y-this.avgY());
  }

  //======================================================================================

  //returns true if the two polygons are intersecting, if not it returns false

  boolean intersectsPolygon(Polygon A) {
    float[] A_xcoords = A.XPoints();
    float[] A_ycoords = A.YPoints();
    float AXmax = A_xcoords[0];
    float AXmin = A_xcoords[0];
    float AYmax = A_ycoords[0];
    float AYmin = A_ycoords[0];
    for (int i = 0; i < A_xcoords.length; i++) {
      AXmax = round(max(AXmax, A_xcoords[i]));
      AXmin = round(min(AXmin, A_xcoords[i]));
      AYmax = round(max(AYmax, A_ycoords[i]));
      AYmin = round(min(AYmin, A_ycoords[i]));
    }
    for (int y = (int)AYmin; y < AYmax; y++) {
      for (int x = (int)AXmin; x < AXmax; x++) {
        if (A.contains(x, y) && this.contains(x, y)) {
          return true;
        }
      }
    }
    return false;
  }

  //======================================================================================

  //resizes the polygon to scl times its original size

  void resizePolygon(float scl) {
    float x1 = this.avgX();
    float y1 = this.avgY();
    for (int i = 0; i < this.index; i++) {
      float distance = dist(this.xcoords[i], this.ycoords[i], x1, y1);
      float x2 = this.xcoords[i];
      float y2 = this.ycoords[i];
      float step1 = (y1-y2)*(y1-y2);
      float step2 = (x1-x2)*(x1-x2);
      float step3 = (step1/step2)+1;
      float step4 = scl*abs(scl)*distance*distance;
      float step5 = step4/step3;
      float step6 = 0;
      if (x2 < x1) {
        step6 = x1-pow(step5, 0.5);
      } else {
        step6 = x1+pow(step5, 0.5);
      }
      this.xcoords[i] = step6;
      float step7 = step6 - x1;
      float step8 = y2-y1;
      float step9 = step8*step7;
      float step10 = step9/(x2-x1);
      float step11 = step10+y1;
      this.ycoords[i] = step11;
    }
  }

  //======================================================================================

  //returns an average x coordinate

  float avgX() {
    float avg = 0;
    for (int i = 0; i < this.index; i++) {
      avg += this.xcoords[i];
    }
    return avg/this.index;
  }

  //======================================================================================

  //returns an average y coordinate

  float avgY() {
    float avg = 0;
    for (int i = 0; i < this.index; i++) {
      avg += this.ycoords[i];
    }
    return avg/index;
  }

  //======================================================================================
}