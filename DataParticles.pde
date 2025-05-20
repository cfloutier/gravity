
class DataParticles extends GenericData
{
  DataParticles() {
    super("Particles");
  }
 //<>//
  boolean draw = true;
  
  int nb_particles = 100;
  float steps_size = 10;
    
  int steps = 1000;

  float min_radius = 500;
  float max_radius = 500;
  
  float min_speed = 1;
  float max_speed = 2;
  
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

  Toggle draw;
  
  Slider nb_particles;
  Slider steps;
  Slider steps_size;

  Slider min_radius;
  Slider max_radius;
  
  Slider min_speed;
  Slider max_speed;
  
  Slider min_distance_to_planets;
  Slider max_distance_to_page;
  
  void setupControls()
  {
    super.Init();

    draw = addToggle("draw", "Draw");
    nextLine();

    nb_particles = addIntSlider("nb_particles", "Nb Particles", 1, 1000);
    steps = addIntSlider("steps", "Steps", 100, 10000);
    steps_size = addSlider("steps_size", "steps size", 0.1, 100);
    
    nextLine();
    space();

    min_radius = addSlider("min_radius", "Spawn Min Radius", 0, 1000);
    max_radius = addSlider("max_radius", "Spawn Max Radius", 0, 1000);
    
    nextLine();
    space();
    
    min_speed = addSlider("min_speed", "Spawn Min Speed", -2, 2);
    max_speed = addSlider("max_speed", "Spawn Max Speed", -2, 2);
    
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
    draw.setValue(data.draw);
    nb_particles.setValue(data.nb_particles);
    steps.setValue(data.steps);
    steps_size.setValue(data.steps_size);
    
    min_radius.setValue(data.min_radius);
    max_radius.setValue(data.max_radius);
    
    min_speed.setValue(data.min_speed);
    max_speed.setValue(data.max_speed);

    min_distance_to_planets.setValue(data.min_distance_to_planets);
    max_distance_to_page.setValue(data.max_distance_to_page);
  }
}
