class DataPlanets extends GenericDataClass
{
  // shown in gui
  int current_index = 0;
  ArrayList<DataPlanet> planets = new ArrayList<DataPlanet>();

  DataPlanets() {
    super("Planets");
  }

  public void LoadJson(JSONObject json) {
    if (json == null) return;

    int nb_planets = json.getInt("nb_planets", 0);
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
    json.getInt("nb_planets", nb_planets);

    for (int i = 0 ; i < nb_planets ; i++)
    {
      DataPlanet planet = planets.get(i);
      json.setJSONObject("planet_"+i, planet.SaveJson());
    }

    json.setInt("current_index", current_index);

    return json;
  }
}

class DataPlanet extends GenericDataClass
{
  float center_x = 0;
  float center_y = 0;

  float size = 0;
  float gravity = 100;

    DataPlanet() {
    super("Planet");
  }

}
