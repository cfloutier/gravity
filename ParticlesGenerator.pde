

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
