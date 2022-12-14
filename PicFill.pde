class PictureFill {
  PImage fillImage;
  PVector showStart;
  PictureFill( PVector tSizeImg, PVector tShowStart ) {
    IniPictureFill( tSizeImg, tShowStart );
  }

  void IniPictureFill( PVector tSizeImg, PVector tShowStart ) {
    fillImage = createImage( int(tSizeImg.x), int(tSizeImg.y), ARGB );
    showStart = tShowStart.copy();

    fillImage.loadPixels();
    for (int i = 0; i < fillImage.pixels.length; i++) {
      fillImage.pixels[i] = color(0, 0, 0, 0);
    }
    fillImage.updatePixels();
  }


  void Update( ArrayList<PVector> tAddPixel ) {
    FillPixel( tAddPixel );
  }

  void FillPixel( ArrayList<PVector> tAddPixel ) {
    for ( PVector tOne : tAddPixel ) {
      fillImage.set( int(tOne.x), int(tOne.y), int(tOne.z) );
    }
  }

  void ShowImg() {
    imageMode( CORNER );
    image( fillImage, showStart.x, showStart.y );
  }
}
