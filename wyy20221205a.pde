PImage pic;
int a =20;


void setup() {
  size(1316, 1016);
  background(255);
  noStroke();
  String url ="https://raw.githubusercontent.com/yeeeesssss/-/main/wooooood.jpg";
  pic = loadImage(url, "jpg");
  //image(pic,0,0);
  //fill(0);
  //ellipse(width/2, height/2, 500, 500);
  //blend(pic, 0, 0, width, height, 0, 0, width, height,ADD);
}



void draw() {
  fill(0);
  noStroke();
  ellipse(mouseX, mouseY, a, a);
  blend(pic, 0, 0, width, height, 0, 0, width, height, ADD);
  
  a=a+3;
}
