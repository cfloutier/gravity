class DataPlanets extends GenericDataClass
{
  boolean show = true;
  // shown in gui
  int current_index = 0;
  ArrayList<DataPlanet> planets = new ArrayList<DataPlanet>();
  
  float max_gravity = 500;
  

  DataPlanet edit_planet = new DataPlanet();

  DataPlanets() {
    super("Planets");
  }

  int nb_planets()
  {
    return planets.size();
  }

  public void LoadJson(JSONObject json) {
    if (json == null) return;

    int nb_planets = json.getInt("nb_planets", 0); //<>//
    current_index = json.getInt("current_index", 0);
    for (int i = 0 ; i < nb_planets ; i++)
    {
      DataPlanet planet = new DataPlanet();
      planet.LoadJson(json.getJSONObject("planet_"+i));
      planets.add(planet);
    }
  }

  public JSONObject SaveJson() {
    JSONObject json = new JSONObject();
    
    int nb_planets = planets.size();
    json.setInt("nb_planets", nb_planets);

    for (int i = 0 ; i < nb_planets ; i++)
    {
      DataPlanet planet = planets.get(i);
      json.setJSONObject("planet_"+i, planet.SaveJson());
    }

    json.setInt("current_index", current_index);

    return json;
  }

  void draw()
  {
    if (!show)
      return;

    strokeWeight(1);   
    color gray = #A0A0A0;
    
    color red =#ff3300;
    color green = #1bfa1f;
      
    for (int i = 0 ; i < nb_planets() ; i++)
    {
      DataPlanet planet = planets.get(i);
      
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

class DataPlanet extends GenericDataClass
{
  float center_x = 0;
  float center_y = 0;

  float size = 10;
  float gravity = 100;

    DataPlanet() {
    super("Planet");
  }
}

class PlanetsGui extends GUIPanel
{
  DataPlanets data = null;
  
  public PlanetsGui(DataPlanets data)
  {
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
    super.Init("Planets", data);

    current_Planet = addLabel("current Planet : 0/0");
    nextLine();
    addToggle("show", "Show", false);
    space();
    addButton("Prev").plugTo(this, "prev");
    addButton("Remove").plugTo(this, "remove");
    addButton("Add").plugTo(this, "add");
    addButton("Next").plugTo(this, "next");

    nextLine();
    space();

    center_button = addButton("Center").plugTo(this, "center");
    center_x = addSlider("center_x", "X", data.edit_planet, -2000, 2000, true);
    center_y  = addSlider("center_y", "Y", data.edit_planet, -2000, 2000, true);

    nextLine();
    space();

    size  = addSlider("size", "Size", data.edit_planet, 0, 1000, true);
    gravity = addSlider("gravity", "Gravity", data.edit_planet, -data.max_gravity, data.max_gravity, true);
  }

  void prev()
  {
    if (data.nb_planets() == 0)
    {
      data.current_index = 0;      
    }
    else
    {
      data.current_index = data.current_index -1;
      if (data.current_index < 0)
        data.current_index = data.nb_planets() -1;

    }

    updatePlanet();
  }

  void next()
  {
    if (data.nb_planets() == 0)
    {
      data.current_index = 0;      
    }
    else
    {
      data.current_index = data.current_index + 1;
      if (data.current_index >= data.nb_planets())
        data.current_index = 0;
    }

    updatePlanet();
  }

  void fix_index()
  {
     if (data.current_index >= data.nb_planets())
      data.current_index = data.nb_planets() -1;
    else if (data.current_index < 0)
      data.current_index = 0;
  }

  void add()
  {
    data.planets.add(new DataPlanet());
    data.current_index = data.planets.size() -1;
    
    updatePlanet();
  }

  void remove()
  {
    if (data.nb_planets() == 0)
      return;

    fix_index();

    data.planets.remove(data.current_index);
    data.current_index--;
    fix_index();  
    updatePlanet();
  }

  void updatePlanet()
  {
    if (data.nb_planets() == 0)
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
      
      DataPlanet planet = data.planets.get(data.current_index);
      data.edit_planet.CopyFrom(planet);

      center_x.setValue(planet.center_x);
      center_y.setValue(planet.center_y);
      size.setValue(planet.size);
      gravity.setValue(planet.gravity);

      current_Planet.setText("Planet " + (data.current_index + 1) + " / " + data.nb_planets());
    }
    else
    {
      DataPlanet planet = data.planets.get(data.current_index);
      planet.CopyFrom(data.edit_planet);
    }
  }

  void update_ui()
  {
    updatePlanet();
  }

  void setGUIValues()
  {
    updatePlanet();
  }
  
  void center()
  {
    center_x.setValue(0);
    center_y.setValue(0);
    
    data.edit_planet.center_x = 0;
    data.edit_planet.center_y = 0;
  }

}
