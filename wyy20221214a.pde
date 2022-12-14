class Configure {
  String fileImg;
  PVector showImgOffset;
  int pixelRatioMove;
  float accelerationSet;
  int waitUpdate;
  int numUpdateOnce;
  Configure() {
    Setting();
  }

  void Setting() {
    fileImg = "./img/blue.jpg";

    showImgOffset = new PVector( 0, -200 );
    pixelRatioMove = 5;
    accelerationSet = 0.1;
    waitUpdate = 3;
    numUpdateOnce = 500;
  }
}
