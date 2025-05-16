import controlP5.*; 


class GravityData extends DataGlobal
{
    DataParticles particles  = new DataParticles();
    Style style = new Style();

    GravityData()
    {
      addChapter(particles);
      addChapter(style);
    }

}
