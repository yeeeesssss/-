boolean d=false;
boolean s=true;
boolean m=false;
boolean l=false;

void setup() {
  size(1280, 900);
  background(#3C3967);
}

void beggin() {
  size(1280, 900);
  background(#3C3967);

  fill(255);
  stroke(0);
  strokeWeight(5);
  rect(310, 10, 960, 870);

  fill(255);
  textSize(80);
  text("draw", 10, 60);

  fill(255);
  textSize(80);
  text("clean", 10, 130);

  fill(255);
  textSize(80);
  text("size", 10, 200);

  fill(255);
  textSize(50);
  text("small", 10, 250);
  fill(255);
  textSize(50);
  text("medium", 10, 310);
  fill(255);
  textSize(50);
  text("large", 10, 370);

  fill(#C1BBB4);
  stroke(0);
  strokeWeight(5);
  rect(230, 20, 70, 40);
  fill(#C1BBB4);
  stroke(0);
  strokeWeight(5);
  rect(230, 90, 70, 40);

  fill(#C1BBB4);
  stroke(0);
  strokeWeight(5);
  rect(250, 210, 40, 40);
  fill(#C1BBB4);
  stroke(0);
  strokeWeight(5);
  rect(250, 270, 40, 40);
  fill(#C1BBB4);
  stroke(0);
  strokeWeight(5);
  rect(250, 340, 40, 40);
}

void mouseClicked() {
  //draw clean
  if (mouseX<300 && mouseX >230) {
    if (mouseY >90 && mouseY < 130) {
      fill(255);
      stroke(0);
      strokeWeight(5);
      rect(310, 10, 960, 870);
      d = false;
    }
    if (mouseY >20 && mouseY<60) {
      d = true ;
    }
  }

  //s m l

  if (mouseX < 290 && mouseX > 250) {
    if (mouseY > 210 && mouseY < 250) {
      s = true;
      m = false;
      l = false;
    }
    if (mouseY > 270 && mouseY < 310) {
      s = false;
      m = true;
      l = false;
    }
    if (mouseY > 340 && mouseY < 380) {
      s = false;
      m = false;
      l = true;
    }
  }
}




void draw() {

  if (d) {

    if (s) {
      if (mouseX >330 && mouseX < 1250) {
        if (mouseY<860 && mouseY >30) {
          fill(#FF0000);
          noStroke();
          ellipse(mouseX, mouseY, 20, 20);
        }
      }
    }


    if (m) {
      if (mouseX >330 && mouseX < 1250) {
        if (mouseY<860 && mouseY >30) {
          fill(#FF0000);
          noStroke();
          ellipse(mouseX, mouseY, 35, 35);
        }
      }
    }

    if (l) {
      if (mouseX >330 && mouseX < 1250) {
        if (mouseY<860 && mouseY >30) {
          fill(#FF0000);
          noStroke();
          ellipse(mouseX, mouseY, 50, 50);
        }
      }
    }
  } else {
    beggin();
  }
}
