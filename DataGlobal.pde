import controlP5.*; 

class GravityData extends DataGlobal
{
    DataParticles particles = new DataParticles();
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
      particles.CopyFrom(new DataParticles());

      // needed to be reset it's proper way
      spawners.reset(); 
      planets.reset();

      style.CopyFrom(new Style());
    }
    
}

class DataGUI extends MainPanel
{
  
  DataGlobal data;
  
  ParticlesGUI particles_ui;
  SpawnersGui spawners_ui;
  PlanetsGui planets_gui;
  StyleGUI style_gui;

   public DataGUI(GravityData data)
  {
    this.data = data;
    
    particles_ui = new ParticlesGUI(data.particles); 
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
