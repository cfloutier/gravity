class DataPlanets extends DataList
{
  
  float max_gravity = 500;
  
  DataPlanet edit_planet = new DataPlanet();

  DataPlanets() {
    super("Planets", "planet");
  }

  void reset()
  {
    super.reset();
    
    edit_planet.CopyFrom(new DataPlanet());
  }
  
  DataPlanet newItem()
  {
    return new DataPlanet();
  }
  
  DataPlanet planet(int index)
  {
    return (DataPlanet) items.get(index);
  }

  void draw()
  {
    strokeWeight(1);   
    color gray = #A0A0A0;  //<>//
    
    color red =#ff3300;
    color green = #1bfa1f;
      
    for (int i = 0 ; i < size() ; i++)
    {
      DataPlanet planet = planet(i);
      
      stroke(data.style.lineColor.col);
      
      if (current_index == i)
      {
        float ratio = inverseLerp(-max_gravity, max_gravity, planet.gravity);
        color c = lerpColor(red, green, ratio);
        stroke(c);
      }
      else
        stroke(gray);

      circle(planet.center_x, planet.center_y, planet.drawSize());
    }
  }
}

class DataPlanet extends GenericData
{
  float center_x = 0;
  float center_y = 0;

  float size = 10;
  float gravity = 100;
  float drag = 1;

    DataPlanet() {
    super("Planet");
  }
  
  
  float drawSize()
  {
    if (size < 20)
       return 20;
       
    return size;
  }
}

class PlanetsGui extends GUIListPanel
{
  DataPlanets pdata = null;
  
  PlanetsGui(DataPlanets data)
  {
    super("Planets", data);
     this.pdata = data;
  }

  int last_index = -1;

  Textlabel current_Planet;
  Button center_button;

  Slider center_x;
  Slider center_y;
  Slider size;
  Slider gravity;
  Slider drag;
  
  void setupControls()
  {
    super.Init();

    addListBar();

    current_Planet = addLabel("current Planet : ??");
 
    center_button = addButton("Center").plugTo(this, "center");
    center_x = addSlider("center_x", "X", pdata.edit_planet, -2000, 2000);
    center_y  = addSlider("center_y", "Y", pdata.edit_planet, -2000, 2000);

    nextLine();
    space();

    size  = addSlider("size", "Size", pdata.edit_planet, 0, 1000);
    gravity = addSlider("gravity", "Gravity", pdata.edit_planet, -pdata.max_gravity, pdata.max_gravity);
    drag = addSlider("drag", "Drag", pdata.edit_planet, 0, 100);
  }

  void updateCurrentItem()
  {
    if (pdata.size() == 0)
    {
      center_button.hide();
      center_x.hide();
      center_y.hide();
      size.hide();
      gravity.hide();
      drag.hide();

      current_Planet.setText("No Planet");

      return;
    }

    center_button.show();
    center_x.show();
    center_y.show();
    size.show();
    gravity.show(); 
    drag.show();

    if (pdata.current_index != last_index)
    {
      last_index = pdata.current_index;
      
      DataPlanet planet = pdata.planet(pdata.current_index);
      pdata.edit_planet.CopyFrom(planet);
      
      // println("edit_planet changed");
      // println("edit_planet.size " + pdata.edit_planet.size); 

      center_x.setValue(planet.center_x);
      center_y.setValue(planet.center_y);
      size.setValue(planet.size);
      gravity.setValue(planet.gravity);
      drag.setValue(planet.drag);

      current_Planet.setText("Planet " + (pdata.current_index + 1) + " / " + pdata.size());
    }
    else
    {
      DataPlanet planet = pdata.planet(pdata.current_index);
      planet.CopyFrom(pdata.edit_planet);
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
    
    pdata.edit_planet.center_x = 0;
    pdata.edit_planet.center_y = 0;
  }

  void draw()
  {
    if (tab.isActive())
      pdata.draw();
  }

  PVector mousePosition()
  {
    return new PVector( (mouseX-width/2)/data.global_scale, (mouseY-height/2)/data.global_scale);
  }
  
  PVector last_mouse_pos;;
  
  boolean mousePressed()
  {
    // check if a planet is hit
    PVector pos = mousePosition();
    
    int index = 0;
    for (GenericData item: pdata.items)
    {
      DataPlanet planet = (DataPlanet) item;
      PVector planet_pos = new PVector(planet.center_x, planet.center_y );
      float dist = PVector.dist(planet_pos, pos);
      if (dist < planet.drawSize())
      {
        last_mouse_pos = pos;
        pdata.current_index = index;
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
    
    DataPlanet planet = (DataPlanet) pdata.items.get(pdata.current_index);
    
    planet.center_x -= delta.x;
    planet.center_y -= delta.y;
    
    center_x.setValue(planet.center_x);
    center_y.setValue(planet.center_y);
    
    last_mouse_pos = pos;
  }

  void mouseReleased()
  {
    // called if drag has started on mouse up
  }

}
