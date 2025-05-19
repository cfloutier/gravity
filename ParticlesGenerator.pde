

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
    
    boolean stopped = false;

    Line line = new Line();
    GravityData data = null;
    
    Particle(GravityData data)
    {
        this.data = data;
        float radius = random(data.particles.min_radius, data.particles.max_radius);
        float direction = random(PI*2);

        float speed_direction = random(PI*2);
        float speed_v = random(data.particles.min_speed, data.particles.max_speed);
        
        //println("radius " + radius);

        position = new PVector(radius* cos(direction), radius*sin(direction) );
        speed = new PVector(speed_v* cos(speed_direction), speed_v*sin(speed_direction) );

        line.add(position);
    }

    PVector computeForce()
    {
        PVector force = new PVector(0,0);
        for (GenericData item: data.planets.items)
        {
          DataPlanet planet = (DataPlanet) item;
          
            PVector delta = new PVector(planet.center_x-position.x,planet.center_y-position.y);
            float distance_2 = delta.magSq();
            float distance = sqrt(distance_2);

            if (distance < data.particles.min_distance_to_planets)
            {
              stopped = true;
              return new PVector(0,0);
            }

            if (distance < planet.size)
            {
              force.add( -speed.x/(1+planet.drag), -speed.y/(1+planet.drag) );
              
            }
            

            delta.normalize();


            float power = planet.gravity/distance_2;
            force.add(power*delta.x, power*delta.y );
        }

        return force;
    }

    void move()
    {
        if (stopped)
          return;

        PVector force = computeForce();  
       
        speed.x += force.x * data.particles.steps_size;
        speed.y += force.y * data.particles.steps_size;
        position = new PVector(position.x + speed.x * data.particles.steps_size, position.y + speed.y * data.particles.steps_size);
        
        if (position.mag() > data.particles.max_distance_to_page)
        {
          stopped = true;
          return;
        }

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

  GravityData data;

  public ParticlesGenerator(GravityData data) {
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
    //println("build lines");
    particles.clear();
    
    randomSeed(0);
    
    for (int i = 0 ; i < data.particles.nb_particles; i++)
    {
        particles.add( new Particle(data) );  
    }
    
    for (int i = 0 ; i < data.particles.steps; i++)
    {
        for (Particle p: particles)
        {
            p.move();
            //p.print();
        }
    }
  }
}
