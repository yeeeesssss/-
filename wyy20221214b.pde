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


class Main {
  Configure confs;
  PixelMatrix pixelMatrix;
  PictureFill picFill;
  int waitUpdate;
  int countUpdate;
  int numUpdateOnce;
  Main() {
    IniMain();
  }

  void IniMain() {
    confs = new Configure();
    pixelMatrix = new PixelMatrix();
    pixelMatrix.IniPixelMatrix( confs );
    picFill = new PictureFill( pixelMatrix.GetMatrixSize(), pixelMatrix.GetShowStart() );
    waitUpdate = confs.waitUpdate;
    numUpdateOnce = max( 1, confs.numUpdateOnce);
  }

  void Ready() {
    pixelMatrix.PointsGotoStart();
    pixelMatrix.SetPointsTarget();
    countUpdate = 0;
    if ( waitUpdate <= 0 ) {
      pixelMatrix.SetUpdateEnable();
    }
  }
  void Run() {

    picFill.Update( pixelMatrix.Update() );
    picFill.ShowImg();
    if ( pixelMatrix.GetHasRowColRandomNext() == false ) {
      return;
    }
    SetUpdateEnable( GetNextUpdateIndex() );
  }

  void SetUpdateEnable( PVector[] tPointUpdate ) {
    if ( tPointUpdate == null || tPointUpdate.length <= 0 ) {
      return;
    }
    for ( int k=0; k<tPointUpdate.length; k++ ) {
      pixelMatrix.SetUpdateEnable( int(tPointUpdate[k].x), int(tPointUpdate[k].y) );
    }
  }
  PVector[] GetNextUpdateIndex() {
    PVector[] tOuts = new PVector[]{};
    if ( countUpdate >= waitUpdate ) {
      tOuts = new PVector[numUpdateOnce];
      for ( int h=0; h<numUpdateOnce; h++  ) {
        tOuts[h] = pixelMatrix.GetRowColRandomNext();
      }
      countUpdate = 0;
    } else {
      countUpdate += 1;
    }
    return tOuts;
  }
}

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

class PixelMatrix {

  PixelOne[][] pixelArray;
  boolean[][] pixelsUpdate;
  PVector pointsStart;
  int pixelRatioShow;
  ArrayList<PVector> arrayRowCol;

  PixelMatrix() {
  }

  void IniPixelMatrix( Configure tConfs ) {
    pixelRatioShow = 1;
    arrayRowCol = new ArrayList<PVector>();
    PImage tImage = loadImage( tConfs.fileImg );
    tImage.loadPixels();
    IniPixels( new PVector(tImage.width, tImage.height), tConfs.showImgOffset, tConfs.pixelRatioMove, tConfs.accelerationSet, tImage.pixels  );
  }

  void IniPixels( PVector tSideLength, PVector tShowOffset, int tSizeRatioMove, float tAccelerationSet, color[] tColors ) {
    PVector tPoint = new PVector( 0, 0 );
    pointsStart = new PVector( int(width/2-(tSideLength.x*pixelRatioShow)/2+tShowOffset.x), int(height/2+tShowOffset.y) );
    pixelArray = new PixelOne[int(tSideLength.y)][int(tSideLength.x)];
    pixelsUpdate = new boolean[int(tSideLength.y)][int(tSideLength.x)];
    arrayRowCol.clear();
    for ( int y=0; y<tSideLength.y; y++ ) {
      tPoint.y = pointsStart.y + y*pixelRatioShow;
      for ( int x=0; x<tSideLength.x; x++ ) {
        tPoint.x = pointsStart.x + x*pixelRatioShow;
        pixelArray[y][x] = new PixelOne( tPoint, new PVector[]{new PVector(tSizeRatioMove, tSizeRatioMove), new PVector(pixelRatioShow, pixelRatioShow)}, tAccelerationSet );
        pixelArray[y][x].SetColors( tColors[int(y*tSideLength.x+x)], 255, tColors[int(y*tSideLength.x+x)], 255 );
        pixelsUpdate[y][x] = false;
        arrayRowCol.add( new PVector( x, y ) );
      }
    }
  }


  void SetUpdateEnable( int tX, int tY ) {
    pixelsUpdate[tY][tX] = true;
  }

  void SetUpdateEnable() {
    for ( int y=0; y<pixelsUpdate.length; y++ ) {
      for ( int x=0; x<pixelsUpdate[y].length; x++ ) {
        SetUpdateEnable( x, y );
      }
    }
    arrayRowCol.clear();
  }


  ArrayList<PVector> Update() {
    ArrayList<PVector> tOuts = new ArrayList<PVector>();
    for ( int y=0; y<pixelArray.length; y++ ) {
      for ( int x=0; x<pixelArray[y].length; x++ ) {
        if ( pixelsUpdate[y][x] == true ) {
          if ( pixelArray[y][x].Update() == 1 ) {
            tOuts.add( new PVector( x, y, pixelArray[y][x].GetColorNow() ) );
          }
        }
      }
    }
    return tOuts;
  }


  void PointsGotoStart() {
    for ( int y=0; y<pixelArray.length; y++ ) {
      for ( int x=0; x<pixelArray[y].length; x++ ) {
        pixelArray[y][x].SetPointGoto( new PVector( width/2, height ) );
      }
    }
  }


  PVector GetRowColRandomNext() {
    if ( GetHasRowColRandomNext() == false ) {
      return new PVector();
    }
    int tempIndex;
    PVector tempOut;
    tempIndex = int( random( 0, arrayRowCol.size()-1 ) );
    tempOut = arrayRowCol.get(tempIndex).copy();
    arrayRowCol.remove( tempIndex );
    return tempOut;
  }

  boolean GetHasRowColRandomNext() {
    if ( arrayRowCol.size() <= 0 ) {
      return false;
    }
    return true;
  }


  void SetPointsTarget() {
    for ( int y=0; y<pixelArray.length; y++ ) {
      for ( int x=0; x<pixelArray[y].length; x++ ) {
        pixelArray[y][x].SetPointTarget( pixelArray[y][x].pointImg, true );
      }
    }
  }

  void SetAcceleration( float tAcceleration ) {
    for ( int y=0; y<pixelArray.length; y++ ) {
      for ( int x=0; x<pixelArray[y].length; x++ ) {
        pixelArray[y][x].SetAcceleration( tAcceleration );
      }
    }
  }

  PVector GetMatrixSize() {
    return new PVector( pixelArray[0].length, pixelArray.length );
  }
  PVector GetShowStart() {
    return pointsStart;
  }
}

class PixelOne {
  PVector pointImg;
  color[] colorRGB;
  int[] colorAlpha;
  PVector[] size;
  PVector pointNow;
  PVector pointTarget;
  PVector speedNow;
  PVector acceleration;
  float accelerationSet;
  int moveProgress;

  PixelOne() {
  }

  PixelOne( PVector tPoint, PVector[] tSizes, float tAccelerationSet ) {
    SetPixel( tPoint, tSizes, tAccelerationSet );
  }


  void SetPixel( PVector tPoint, PVector[] tSizes, float tAccelerationSet ) {
    pointImg = tPoint.copy();
    pointNow = tPoint.copy();
    pointTarget = tPoint.copy();
    size = new PVector[]{ tSizes[0].copy(), tSizes[1].copy() };
    accelerationSet = tAccelerationSet;
    speedNow = new PVector();
  }

  void SetColors( color tColorMove, int tAlphaMove, color tColorTarget, int tAlphaTarget ) {
    colorRGB = new color[]{ tColorMove, tColorTarget };
    colorAlpha = new int[]{ tAlphaMove, tAlphaTarget };
  }

  void SetAcceleration( float tAcceleration ) {
    accelerationSet = tAcceleration;
  }


  void SetPointTarget( PVector tPointTarget, boolean tSpeedUp ) {
    moveProgress = 0;
    pointTarget = tPointTarget.copy();

    acceleration = PVector.sub( pointTarget, pointNow );
    acceleration.normalize();
    if ( tSpeedUp == true ) {
      acceleration.mult( accelerationSet );
      speedNow = new PVector( 0, 0 );
    } else {
      acceleration.mult( -1.0*accelerationSet );
      speedNow.x = sqrt( 2.0*abs(acceleration.x*(pointTarget.x-pointNow.x)) )*(pointTarget.x>pointNow.x?1:-1);
      speedNow.y = sqrt( 2.0*abs(acceleration.y*(pointTarget.y-pointNow.y)) )*(pointTarget.y>pointNow.y?1:-1);
    }
  }

  void SetPointGoto( PVector tPointTarget ) {
    moveProgress = 0;
    pointNow = tPointTarget.copy();
    pointTarget = tPointTarget.copy();
  }


  int Update() {
    if ( moveProgress >= 2 ) {
      return moveProgress;
    } else if ( moveProgress == 1 ) {
      moveProgress ++;
      return moveProgress;
    } else if ( PVector.dist(pointTarget, pointNow) <= max(1, PVector.dist(speedNow, new PVector())/1.0) ) {
      moveProgress = 1;
      pointNow = pointTarget.copy();
    } else {
      pointNow.add( speedNow );
      speedNow.add( acceleration );
    }

    noStroke();

    fill( colorRGB[moveProgress], colorAlpha[moveProgress] );
    rect( pointNow.x, pointNow.y, pointNow.x-pointTarget.x, pointNow.y-pointTarget.y );
    return moveProgress;
  }


  public color GetColorNow() {
    return colorRGB[moveProgress];
  }
}
