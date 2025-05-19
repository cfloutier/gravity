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

class DataGUI
{
   public DataGUI(GravityData data)
  {
    this.data = data;
    particles_ui = new ParticlesGUI(data.particles); 
    planets_gui = new PlanetsGui(data.planets); 
    style_gui = new StyleGUI(data.style); 
  }  

  DataGlobal data;
  ParticlesGUI particles_ui;
  PlanetsGui planets_gui;
  StyleGUI style_gui;
  
  // update UI for all non controller (labels or hide/show)
  void update_ui()
  {
    if (!data.changed && !data.need_update_ui )
      return;

    particles_ui.update_ui();  
    planets_gui.update_ui();  
    style_gui.update_ui();  
  }
  
  void setupControls()
  { 
    style_gui.setupControls();  
    particles_ui.setupControls(  ) ;
    planets_gui.setupControls(); 
    cp5.getTab("Planets").bringToFront();
  }
  
  void setGUIValues()
  {
    particles_ui.setGUIValues();
    style_gui.setGUIValues();
    planets_gui.setGUIValues();
  }
}
