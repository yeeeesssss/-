int a=10;
void setup(){
  size(1200,1200);
  background(#D4C9DE);
  
  
}
  
  
  void draw(){
    
    fill(#F0D433,20);
    strokeWeight(3);
    stroke(255);
  ellipse(mouseX,mouseY,a,a);
  
  a=a+3;
}
