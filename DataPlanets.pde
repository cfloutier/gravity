class DataPlanets extends DataList
{
  
  float max_gravity = 500;
  
  DataPlanet edit_planet = new DataPlanet();

  DataPlanets() {
    super("Planets", "planet");
  }

  void reset()
  {
    
  }
  
  DataPlanet newItem()
  {
    return new DataPlanet();
  }

  void draw()
  {
    strokeWeight(1);   
    color gray = #A0A0A0;
    
    color red =#ff3300;
    color green = #1bfa1f;
      
    for (int i = 0 ; i < size() ; i++) //<>//
    {
      DataPlanet planet = (DataPlanet) items.get(i);
      
      stroke(data.style.lineColor.col);
      
      if (current_index == i)
      {
        float ratio = inverseLerp(-max_gravity, max_gravity, planet.gravity);
        color c = lerpColor(red, green, ratio);
        stroke(c);
      }
      else
        stroke(gray);

      circle(planet.center_x, planet.center_y, planet.size);
    }
  }
}

class DataPlanet extends GenericData
{
  float center_x = 0;
  float center_y = 0;

  float size = 10;
  float gravity = 100;

    DataPlanet() {
    super("Planet");
  }
}


class PlanetsGui extends GUIListPanel
{
  DataPlanets data = null;
  
  PlanetsGui(DataPlanets data)
  {
    super("Planets", data);
     this.data = data;
  }

  int last_index = -1;

  Textlabel current_Planet;
  Button center_button;

  Slider center_x;
  Slider center_y;
  Slider size;
  Slider gravity;
  
  
  void setupControls()
  {
    super.Init();

    current_Planet = addLabel("current Planet : 0/0");
    nextLine();
    
    space();
    
    
    addButton("Prev").plugTo(this, "prev");
    addButton("Remove").plugTo(this, "remove");
    addButton("Add").plugTo(this, "add");
    addButton("Next").plugTo(this, "next");

    nextLine();
    space();

    center_button = addButton("Center").plugTo(this, "center");
    center_x = addSlider("center_x", "X", data.edit_planet, -2000, 2000);
    center_y  = addSlider("center_y", "Y", data.edit_planet, -2000, 2000);

    nextLine();
    space();

    size  = addSlider("size", "Size", data.edit_planet, 0, 1000);
    gravity = addSlider("gravity", "Gravity", data.edit_planet, -data.max_gravity, data.max_gravity);
  }

  void updateCurrentItem()
  {
    if (data.size() == 0)
    {
      center_button.hide();
      center_x.hide();
      center_y.hide();
      size.hide();
      gravity.hide();
      current_Planet.setText("No Planet");
      return;
    }

    center_button.show();
    center_x.show();
    center_y.show();
    size.show();
    gravity.show(); 

    if (data.current_index != last_index)
    {
      last_index = data.current_index;
      
      DataPlanet planet = (DataPlanet) data.items.get(data.current_index);
      data.edit_planet.CopyFrom(planet);
      
      println("edit_planet changed");
      println("edit_planet.size " + data.edit_planet.size); 

      center_x.setValue(planet.center_x);
      center_y.setValue(planet.center_y);
      size.setValue(planet.size);
      gravity.setValue(planet.gravity);

      current_Planet.setText("Planet " + (data.current_index + 1) + " / " + data.size());
    }
    else
    {
      DataPlanet planet = (DataPlanet) data.items.get(data.current_index);
      planet.CopyFrom(data.edit_planet);
      data.changed = true;
      // println("data changed");
     // println("planet.size " + planet.size); 
     // println("edit_planet.size " +data.edit_planet.size); 
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
    
    data.edit_planet.center_x = 0;
    data.edit_planet.center_y = 0;
  }

  void draw()
  {
    if (tab.isActive())
      data.draw();
  }

}
