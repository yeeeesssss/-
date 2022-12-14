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
