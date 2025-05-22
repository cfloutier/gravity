import controlP5.*; 

class GravityData extends DataGlobal
{
    DataCanvas particles = new DataCanvas();
    DataSpawners spawners = new DataSpawners();
    DataPlanets planets = new DataPlanets();
    Style style = new Style();

    GravityData()
    {
      reset();
      
      addChapter(style);
      addChapter(particles);
      addChapter(spawners);
      addChapter(planets);
    }
    
    void reset()
    {
      particles.CopyFrom(new DataCanvas());

      // needed to be reset it's proper way
      spawners.reset(); 
      planets.reset();

      style.CopyFrom(new Style());
    }
    
}

class DataGUI extends MainPanel
{
  
  DataGlobal data;
  
  CanvasGUI particles_ui;
  SpawnersGui spawners_ui;
  PlanetsGui planets_gui;
  StyleGUI style_gui;

   public DataGUI(GravityData data)
  {
    this.data = data;
    
    particles_ui = new CanvasGUI(data.particles); 
    spawners_ui = new SpawnersGui(data.spawners); 
    planets_gui = new PlanetsGui(data.planets); 
    style_gui = new StyleGUI(data.style); 
  }
  
  void Init()
  {
    addTab(particles_ui);
    addTab(spawners_ui);
    addTab(planets_gui);
    addTab(style_gui);
    super.Init();

    cp5.getTab("Spawners").bringToFront();
  }
}
