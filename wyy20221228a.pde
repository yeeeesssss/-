String textS;
PFont font;
int fs =40;


void setup() {
  
  size(800, 800);
  textS = "circle and circle I go around";
  font = createFont("华文彩云",fs);
  textFont(font);
  textSize(fs);
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100);
  noLoop();
}

void draw() {
  background(0, 0, 100);
  char[] textChar = getChars(textS);
  float r = 360;
  float a0 = -PI/6*5;
  float a1 = -PI/6;
  pushMatrix();
  translate(width/2, height/2);
  noFill();
  stroke(0, 0, 80);
  ellipse(0, 0, r*2, r*2);
  fill(60, 80, 80);
  bendingCircle(textS, a0, a1, r, true);
  popMatrix();
  a0 = PI/6*5;
  a1 = PI/6;
  pushMatrix();
  translate(width/2, height/2);
  noFill();
  ellipse(0, 0, r*2, r*2);
  fill(120, 80, 80);
  bendingCircle(textS, a0, a1, r, false);// 
  popMatrix();
  // bezier
  float[][] bPs = new float[4][2];
  bPs[0][0]=width/6;
  bPs[0][1]=height/2*1.1;
  bPs[1][0]=width/6*2.5;
  bPs[1][1]=height/4*0.05;
  bPs[2][0]=width/6*3.5;
  bPs[2][1]=height/4*3.95;
  bPs[3][0]=width/6*5;
  bPs[3][1]=height/2*0.9;
  pushMatrix();
  translate(0, -height/6);
  noFill();
  bezier(bPs[0][0], bPs[0][1], bPs[1][0], bPs[1][1], bPs[2][0], bPs[2][1], bPs[3][0], bPs[3][1]);
  fill(180, 80, 80);
  bendingBezierT(textS, bPs);
  popMatrix();
  noFill();
  bezier(bPs[0][0], bPs[0][1], bPs[1][0], bPs[1][1], bPs[2][0], bPs[2][1], bPs[3][0], bPs[3][1]);
  fill(240, 80, 80);
  bendingBezierD(textS, bPs, 100);
  pushMatrix();
  translate(0, height/6);
  noFill();
  bezier(bPs[0][0], bPs[0][1], bPs[1][0], bPs[1][1], bPs[2][0], bPs[2][1], bPs[3][0], bPs[3][1]);//bezier曲线
  fill(360, 80, 80);
  bendingBezierD(textS, bPs, 50000);
  popMatrix();
}


void bendingCircle(String s, float a0, float a1, float r, boolean cw) {
  char[] textChar = getChars(s);
  float angle = a0;
  float dAngle = (a1-a0)/(textChar.length-1);
  for (int i=0; i<s.length(); i++) {
    pushMatrix();
    translate(r*cos(angle), r*sin(angle));
    if (cw) {
      rotate(angle+PI/2);
    } else {
      rotate(angle-PI/2);
    }
    text(textChar[i], cos(angle), sin(angle));
    popMatrix();
    angle+=dAngle;
  }
}

void bendingBezierT(String s, float[][] bPs) {
  char[] textChar = getChars(s);
  for (int i = 0; i < s.length(); i++) {
    float t = i / float(s.length()-1);
    float x = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t);
    float y = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t);
    float tx = bezierTangent(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t);
    float ty = bezierTangent(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t);
    float angle = atan2(ty, tx);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    text(textChar[i], cos(angle), sin(angle));
    popMatrix();
  }
}


void bendingBezierD(String s, float[][] bPs, int n) {
  char[] textChar = getChars(s);
  if (n<textChar.length) {
    n=textChar.length;
  }
  float[] blt = getBezierT(bPs, n, textChar.length); 
  for (int i=0; i<blt.length; i++) {
    float x = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], blt[i]);
    float y = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], blt[i]);
    float tx = bezierTangent(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], blt[i]);
    float ty = bezierTangent(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], blt[i]);
    float angle = atan2(ty, tx);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    text(textChar[i], cos(angle), sin(angle));
    popMatrix();
  }
}

char[] getChars(String s) {
  char[] chars = new char[0];
  for (int i=0; i<s.length(); i++) {
    chars=append(chars, s.charAt(i));
  }
  return(chars);
}

float[] getBezierT(float[][] bPs, int n, int numT) {
  float[] tA = new float[numT];
  float bl = calBezierLength(bPs, n);
  float p=1/float(n);
  float eachBL = bl/numT;
  tA[0]=0;
  for (int i = 0; i < numT-1; i++) {
    float cL=0;
    for (float t = tA[i]; t<1; t+=p) {
      float cx = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t);
      float cy = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t);
      float nx = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t+p);
      float ny = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t+p);
      cL+=dist(cx, cy, nx, ny);
      if (cL>=eachBL) {
        float pL = cL-dist(cx, cy, nx, ny);
        if ((eachBL-pL)<=(cL-eachBL)) {
          tA[i+1]=t;
        } else {
          tA[i+1]=t+p;
        }
        break;
      }
    }
  }
  return(tA);
}

float calBezierLength(float[][] bPs, int n) {
  float bl=0;
  float p = 1/float(n);
  for (float t=p; t<=1; t+=p) {
    float px = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t-p);
    float py = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t-p);
    float cx = bezierPoint(bPs[0][0], bPs[1][0], bPs[2][0], bPs[3][0], t);
    float cy = bezierPoint(bPs[0][1], bPs[1][1], bPs[2][1], bPs[3][1], t);
    bl+=dist(px, py, cx, cy);
  }
  return(bl);
}
