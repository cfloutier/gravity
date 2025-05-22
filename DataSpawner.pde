

class DataSpawner extends GenericData
{
  int nb_particles = 100;
  float center_x = 0;
  float center_y = 0;
  
  float radius = 10;
  

  float direction = 0;
  float range_direction = 30;
  float min_speed = 1;
  float max_speed = 10;

  DataSpawner() {
    super("Spawner");
  }

  float drawRadius()
  {
    if (radius < 20)
      return 20;

    return radius;
  }
}

class DataSpawners extends DataList
{
  DataSpawner edit_spawner = new DataSpawner();

  DataSpawners() {
    super("Spwaners", "spawner");
  }

  void reset()
  {
    super.reset();

    edit_spawner.CopyFrom(new DataSpawner());
  }

  DataSpawner newItem()
  {
    return new DataSpawner();
  }

  DataSpawner spawner(int index)
  {
    return (DataSpawner) items.get(index);
  }

  void draw(boolean active)
  {
    strokeWeight(1);

    color darkblue =#002a69;
    color green = #1bfa1f;

    for (int i = 0; i < count(); i++)
    {
      DataSpawner spawner = spawner(i);

      if (active)
      {
        if (current_index == i)
        {
          stroke(green);
        } else
          stroke(darkblue);

      }
      else 
        stroke(darkblue);

      circle(spawner.center_x, spawner.center_y, spawner.drawRadius()*2);
      
      strokeWeight(3);
      
      PVector dir_vector_1 = new PVector(cos(radians(spawner.direction-spawner.range_direction)), sin(radians(spawner.direction-spawner.range_direction)));
      PVector dir_vector_2 = new PVector(cos(radians(spawner.direction+spawner.range_direction)), sin(radians(spawner.direction+spawner.range_direction)));
       
      line(spawner.center_x, spawner.center_y, 
          spawner.center_x + dir_vector_1.x*spawner.min_speed*100,  
          spawner.center_y + dir_vector_1.y*spawner.min_speed*100
          );
          
     line(spawner.center_x, spawner.center_y, 
          spawner.center_x + dir_vector_2.x*spawner.min_speed*100,   
          spawner.center_y + dir_vector_2.y*spawner.min_speed*100
          );
        
          
      strokeWeight(1);
      
      line(spawner.center_x, spawner.center_y, 
          spawner.center_x + dir_vector_1.x*spawner.max_speed*100,  
          spawner.center_y + dir_vector_1.y*spawner.max_speed*100
          );
          
     line(spawner.center_x, spawner.center_y, 
          spawner.center_x + dir_vector_2.x*spawner.max_speed*100,  
          spawner.center_y + dir_vector_2.y*spawner.max_speed*100
          ); 
    }
  }
}


class SpawnersGui extends GUIListPanel
{
  DataSpawners sdata = null;

  SpawnersGui(DataSpawners data)
  {
    super("Spawners", data);
    this.sdata = data;
  }

  
  Textlabel current_Spawner;

  Button center_button;
  
  Slider nb_particles;
  
  Slider center_x;
  Slider center_y;
  
  Slider radius;
  Slider direction;
  Slider range_direction;
  Slider min_speed;
  Slider max_speed;

  void setupControls()
  {
    super.Init();

    addListBar();

    current_Spawner = addLabel("current Spawner : ??");
    
    nb_particles = addSlider("nb_particles", "Nb particles", sdata.edit_spawner, 0, 200);
    
    nextLine();
    center_button = addButton("Center").plugTo(this, "center");
    center_x = addSlider("center_x", "X", sdata.edit_spawner, -2000, 2000);
    center_y  = addSlider("center_y", "Y", sdata.edit_spawner, -2000, 2000);

    nextLine();
    space();

    radius  = addSlider("radius", "Radius", sdata.edit_spawner, 0, 1000);
    
    nextLine();
    
    direction  = addSlider("direction", "Direction", sdata.edit_spawner, -180, 180);
    range_direction  = addSlider("range_direction", "Range", sdata.edit_spawner, 0, 180);

    nextLine();

    min_speed  = addSlider("min_speed", "Min Speed", sdata.edit_spawner, 0, 10);
    max_speed  = addSlider("max_speed", "Max Speed", sdata.edit_spawner, 0, 10);

  }

  void updateCurrentItem()
  {
    if (sdata.count() == 0)
    {
      nb_particles.hide();
      center_button.hide();
      center_x.hide();
      center_y.hide();
      radius.hide();
      direction.hide();
      range_direction.hide();
      min_speed.hide();
      max_speed.hide();

      current_Spawner.setText("No Spawner");

      return;
    }


    nb_particles.show();
    center_button.show();
    center_x.show();
    center_y.show();
      radius.show();
      direction.show();
      range_direction.show();
      min_speed.show();
      max_speed.show();

    if (sdata.current_index != last_index)
    {
      last_index = sdata.current_index;
      
      DataSpawner spawner = sdata.spawner(sdata.current_index);
      sdata.edit_spawner.CopyFrom(spawner);

      nb_particles.setValue(spawner.nb_particles);
      center_x.setValue(spawner.center_x);
      center_y.setValue(spawner.center_y);
      radius.setValue(spawner.radius);
      direction.setValue(spawner.direction);
      range_direction.setValue(spawner.range_direction);
      min_speed.setValue(spawner.min_speed);
      max_speed.setValue(spawner.max_speed);

      current_Spawner.setText("Spawner " + (sdata.current_index + 1) + " / " + sdata.count());
    }
    else
    {
      DataSpawner spawner = sdata.spawner(sdata.current_index);
      spawner.CopyFrom(sdata.edit_spawner);
      data.changed = true;
    }
  }

  void update_ui()
  {
    updateCurrentItem();
  }

  void setGUIValues()
  {
    updateCurrentItem();
  }
  
  void center()
  {
    center_x.setValue(0);
    center_y.setValue(0);
    
    sdata.edit_spawner.center_x = 0;
    sdata.edit_spawner.center_y = 0;
  }

  void draw()
  {

      sdata.draw(tab.isActive());
  }

  PVector mousePosition()
  {
    return new PVector( (mouseX-width/2)/data.global_scale, (mouseY-height/2)/data.global_scale);
  }

  PVector last_mouse_pos;;

  boolean mousePressed()
  {
    // check if a spawner is hit
    PVector pos = mousePosition();
    
    int index = 0;
    for (GenericData item: sdata.items)
    {
      DataSpawner spawner = (DataSpawner) item;
      PVector spawner_pos = new PVector(spawner.center_x, spawner.center_y );
      float dist = PVector.dist(spawner_pos, pos);
      if (dist < spawner.drawRadius())
      {
        last_mouse_pos = pos;
        sdata.current_index = index;
        updateCurrentItem();
        return true;
      }

      index ++;
    }

    return false; 
  }

  void mouseDragged()
  {
    PVector pos = mousePosition();
    // called if drag has started on each mouse move
    PVector delta =  PVector.sub(last_mouse_pos, pos);
    
   // print(delta);
    
    DataSpawner spawner = (DataSpawner) sdata.items.get(sdata.current_index);
    
    spawner.center_x -= delta.x;
    spawner.center_y -= delta.y;
    
    center_x.setValue(spawner.center_x);
    center_y.setValue(spawner.center_y);
    
    last_mouse_pos = pos;
  }

  void mouseReleased()
  {
    // called if drag has started on mouse up
  }

}
