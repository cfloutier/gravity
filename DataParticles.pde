
class DataParticles extends GenericData
{
  DataParticles() {
    super("Particles");
  }
 //<>//
  float steps_size = 10;
    
  int steps = 1000;

  float min_distance_to_planets = 5;
  float max_distance_to_page = 2000;
  
  public void LoadJson(JSONObject json) {
    super.LoadJson(json);
  }
}

class ParticlesGUI extends GUIPanel
{
  DataParticles data;

  public ParticlesGUI(DataParticles data)
  {
    super("Particles", data);
    this.data = data;
  }
 

  Slider steps;
  Slider steps_size;
 
  Slider min_distance_to_planets;
  Slider max_distance_to_page;
  
  void setupControls()
  {
    super.Init();

    nextLine();

   
    steps = addIntSlider("steps", "Steps", 100, 10000);
    steps_size = addSlider("steps_size", "steps size", 0.1, 100);
    
   
    space();
    nextLine();
    
    min_distance_to_planets = addSlider("min_distance_to_planets", "Min Distance to Planets", 5, 100);
    
    nextLine();
 space();
    
    max_distance_to_page = addSlider("max_distance_to_page", "Max Distance Page", 0, 3000);
  }


  void update_ui()
  {
    
  }

  void setGUIValues()
  {
    steps.setValue(data.steps);
    steps_size.setValue(data.steps_size);
    
    min_distance_to_planets.setValue(data.min_distance_to_planets);
    max_distance_to_page.setValue(data.max_distance_to_page);
  }
}
