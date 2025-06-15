
class DataCanvas extends GenericData
{
  DataCanvas() {
    super("Canvas");
  }

  float steps_size = 10;
  int steps = 1000;
  float max_distance_to_page = 2000;

  public void LoadJson(JSONObject json) {
    super.LoadJson(json);
  }
}

class CanvasGUI extends GUIPanel
{
  DataCanvas data;

  public CanvasGUI(DataCanvas data)
  {
    super("Canvas", data);
    this.data = data;
  }
 
  Slider steps;
  Slider steps_size;
  Slider max_distance_to_page;
  
  void setupControls()
  {
    super.Init();

    nextLine();

    steps = addIntSlider("steps", "Steps", 100, 10000);
    steps_size = addSlider("steps_size", "steps size", 0.1, 100);

    nextLine();
    space();
    
    max_distance_to_page = addSlider("max_distance_to_page", "Max Distance Page", 0, 3000);
  }

  void update_ui()
  {
    
  }

  void setGUIValues()
  {
    steps.setValue(data.steps);
    steps_size.setValue(data.steps_size);
    

    max_distance_to_page.setValue(data.max_distance_to_page);
  }
}
