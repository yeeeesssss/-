color[]colur = {#FFFFFF,#000000,#246EFF,#FFAB24,#B631FF};

int w = 1000;
int h = 800;
float lineS = 0;
float colS = 0;

void setup(){
size(1000,800);
background(255);
}

 void mon(){
 for(int line = 0; line < h ; line += lineS+5){
  lineS = random(15,w/3);
    for(int col = 0 ; col < w ;col += colS +5 ){
     colS= random(15,h/4);
     
  color rectColor = colur[int(random(colur.length))];
  fill(rectColor);
  rect(col,line,colS,lineS);

 strokeWeight(5);
 stroke(0);
 float x = col + colS;
 float y = line +lineS;
 line(0,y,w,y);
 line(x,line,x,y);}}
 }






void draw(){
if (mousePressed){
mon();}
save("mon.jpg");}
