
class DataParticles extends GenericDataClass
{
  DataParticles() {
    super("Particles");
  }

  boolean draw = true;


  int nb_particles = 100;
  float steps_size = 10;
    
  int steps = 1000;
  float gravity = 1;

  float min_radius = 500;
  float max_radius = 500;
  
  float min_speed = 1;
  float max_speed = 2;
  
  boolean cleanup = true;
  float cleanup_min_radius = 0;
  float cleanup_max_radius = 1000;

}

class ParticlesGUI extends GUIPanel
{
  DataParticles data;

  public ParticlesGUI(DataParticles data)
  {
    this.data = data;
  }

  Toggle draw;
  
  Slider nb_particles;
  Slider steps;
  Slider steps_size;

  Slider gravity;
  
  Slider min_radius;
  Slider max_radius;
  
  Slider min_speed;
  Slider max_speed;
  
  Toggle cleanup;
  Slider cleanup_min_radius;
  Slider cleanup_max_radius;
  
  void setupControls()
  {
    super.Init("Particles", data);

    draw = addToggle("draw", "Draw", false);

    nb_particles = addIntSlider("nb_particles", "Nb Particles", 1, 1000, false);
    space();
    steps = addIntSlider("steps", "Steps", 100, 10000, true);
    steps_size = addSlider("steps_size", "steps size", 0.1, 100, false);
    
    space();

    gravity = addSlider("gravity", "Gravity", 0, 1000, false);
    space();

    min_radius = addSlider("min_radius", "Min Radius", 0, 1000, true);
    max_radius = addSlider("max_radius", "Max Radius", 0, 1000, false);
    space();
    min_speed = addSlider("min_speed", "Min Speed", -2, 2, true);
    max_speed = addSlider("max_speed", "Max Speed", -2, 2, false);
    
    space();space();
    cleanup = addToggle("cleanup", "Cleanup", false);
    
    cleanup_min_radius = addSlider("cleanup_min_radius", "Min", 0, 1000, true);
    cleanup_max_radius = addSlider("cleanup_max_radius", "Max", 0, 1000, false);
    

  }


  void update_ui()
  {
  }

  void setGUIValues()
  {
    println("DataParticles.setGUIValues");

    draw.setValue(data.draw);
    nb_particles.setValue(data.nb_particles);
    steps.setValue(data.steps);
    steps_size.setValue(data.steps_size);
    
    gravity.setValue(data.gravity);
    
    min_radius.setValue(data.min_radius);
    max_radius.setValue(data.max_radius);
    
    min_speed.setValue(data.min_speed);
    max_speed.setValue(data.max_speed);
    
  cleanup.setValue(data.cleanup);
cleanup_min_radius.setValue(data.cleanup_min_radius);
cleanup_max_radius.setValue(data.cleanup_max_radius);
    
    
  }
}
