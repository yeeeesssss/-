Main main;

void setup() {
  size(1800, 1300);
  main = new Main();
  main.Ready();
}

void draw() {
  background(250);
  main.Run();
}
