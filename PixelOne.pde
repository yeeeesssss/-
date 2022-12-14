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
