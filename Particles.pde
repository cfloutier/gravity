
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


class Line {
  ArrayList<PVector> points =  new ArrayList<PVector>();

  void draw()
  {
    current_graphics.noFill();
    current_graphics.beginShape();

    for (int i = 0; i < points.size(); i++)
    {
      PVector pA = points.get(i);
      current_graphics.vertex(pA.x, pA.y);
    }

    current_graphics.endShape();
  }
  
  void add(PVector p)
  {
    points.add(p);
  }
}


class Particle {
    
    PVector position;
    PVector speed;
    
    boolean invalid = false;

    Line line = new Line();

    Particle(DataParticles data)
    {
        float radius = random(data.min_radius, data.max_radius);
        float direction = random(PI*2);

        float speed_direction = random(PI*2);
        float speed_v = random(data.min_speed, data.max_speed);
        
        //println("radius " + radius);

        position = new PVector(radius* cos(direction), radius*sin(direction) );
        speed = new PVector(speed_v* cos(speed_direction), speed_v*sin(speed_direction) );

        line.add(position);
    }

    void move(DataParticles data)
    {
        if (invalid)
          return;

        float distance_2 = position.x*position.x + position.y*position.y;
        float distance = sqrt(distance_2) ;
        
        if (data.cleanup)
        {
          if (distance < data.cleanup_min_radius || distance > data.cleanup_max_radius)
          {
            invalid = true;
            return;
          }
          
        }
        
        PVector direction = new PVector(-position.x/distance, -position.y/distance);
        float power = data.gravity/distance_2;
        PVector force = new PVector(direction.x*power, direction.y*power);
       
        speed.x += force.x * data.steps_size;
        speed.y += force.y * data.steps_size;
        position = new PVector(position.x + speed.x * data.steps_size, position.y + speed.y * data.steps_size);

        line.add(position);      
    }

    void draw()
    {
        line.draw();
    }
    
    void print()
    {
      println( position.x + " - " + position.y + " | " + speed.x + " - " + speed.y );
    }
}

class ParticlesGenerator {

  ArrayList<Particle> particles =  new ArrayList<Particle>();

  DataParticles data;

  public ParticlesGenerator(DataParticles data) {
    this.data = data;
  }

  void draw() {
    for (int i = 0; i < particles.size(); i++)
    {
      Particle p = particles.get(i);
      p.draw();
    }
  }


  void buildLines() {

    particles.clear();
    
    randomSeed(0);
    
    for (int i = 0 ; i < data.nb_particles; i++)
    {
        particles.add( new Particle(data) );  
    }
    
    for (int i = 0 ; i < data.steps; i++)
    {
        for (Particle p: particles)
        {
            p.move( data );
            //p.print();
        }
    }
  }
}
