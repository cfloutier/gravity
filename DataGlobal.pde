import controlP5.*; 

class GravityData extends DataGlobal
{
    DataParticles particles = new DataParticles();
    DataPlanets planets = new DataPlanets();
    Style style = new Style();

    GravityData()
    {
      reset();
      
      addChapter(style);
      addChapter(particles);
      addChapter(planets);
    }
    
    void reset()
    {
      particles.CopyFrom(new DataParticles());
      planets.CopyFrom(new DataPlanets());
      style.CopyFrom(new Style());
    }
    
}

class DataGUI extends MainPanel
{
  
  DataGlobal data;
  
  ParticlesGUI particles_ui;
  PlanetsGui planets_gui;
  StyleGUI style_gui;

   public DataGUI(GravityData data)
  {
    this.data = data;
    
    particles_ui = new ParticlesGUI(data.particles); 
    planets_gui = new PlanetsGui(data.planets); 
    style_gui = new StyleGUI(data.style); 
  }
  
  void Init()
  {
    addTab(particles_ui);
    addTab(planets_gui);
    addTab(style_gui);
    super.Init();

    cp5.getTab("Planets").bringToFront();
  }
}
