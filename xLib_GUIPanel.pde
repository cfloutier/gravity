
int indexControler = 0;

static final int StartX = 20;
static final int StartY = 20;


static class LabelsHandler
{
  static public ArrayList<Textlabel> labels = new ArrayList<Textlabel>();
  static int label_color;

  static void set_labels_colors(int _color)
  {
    label_color = _color;
    for (Textlabel label : labels)
    {
      label.setColorValue(label_color);
    }
  }
}

class MainPanel
{
  ArrayList<GUIPanel> panels = new ArrayList<GUIPanel>();
  String activeTab = "";
  MainPanel()
  {
  }

  void addTab(GUIPanel panel)
  {
    panels.add(panel);
  }

  void Init()
  {
    // must be called after addTabs

    for (GUIPanel panel : panels)
    {
      panel.Init(); //<>// //<>//
      panel.setupControls(); //<>// //<>//
    }
  }

  void setGUIValues()
  {
    for (GUIPanel panel : panels)
    {
      panel.setGUIValues();
    }
  }

  void update_ui()
  {
    // update all changes in data to controller thats are not user imputs
    // like labels
    // or show hide controls depending on a status

    if (!data.any_change() && !data.need_update_ui )
      return;

    for (GUIPanel panel : panels)
    {
      panel.update_ui();
    }
  }

  void draw()
  {
    // checks if it's not an export
    if (record)
      return;

    for (GUIPanel panel : panels)
    {
      panel.draw();
    }
  }

  GUIPanel dragging_panel;

  void mousePressed()
  {
    if (cp5.isMouseOver())
      return;

    println("mouse pressed " + mouseX);


    for (GUIPanel panel : panels)
    {
      if (!panel.tab.isActive())
        continue;

      if (panel.mousePressed())
      {
        dragging_panel = panel;
        return;
      }
    }

    // if not check the non active panel

     for (GUIPanel panel : panels)
    {
      if (panel.tab.isActive())
        continue;

      if (panel.mousePressed())
      {
        dragging_panel = panel;
        cp5.getTab(dragging_panel.pageName).bringToFront();
        return;
      }
    }
  }

  void mouseDragged()
  {
    if (dragging_panel != null)
    {
      dragging_panel.mouseDragged();
    }
  }

  void mouseReleased() {

    if (dragging_panel != null)
    {
      dragging_panel.mouseReleased();
      dragging_panel = null;
    }
  }
}

void mousePressed() {
    dataGui.mousePressed();
}

void mouseDragged() {
    dataGui.mouseDragged();
}

void mouseReleased() {
    dataGui.mouseReleased();
}


class GUIPanel implements ControlListener
{
  String pageName;

  float xPos = 0;
  float yPos = 0;

  int xspace = 15;

  int widthCtrl = 300;
  int heightCtrl = 20;


  GenericData associated_data;


  GUIPanel(String pageName, GenericData data)
  {
    this.pageName = pageName;
    this.associated_data = data;
  }

  Tab tab;

  void Init()
  {
    tab = cp5.addTab(pageName);
    //print (" tab " + tab);
    println("add tab " + pageName);

    cp5.addListener(this);

    yPos = StartY;
    xPos = StartX;
  }

  //////////////////////////// virtual functions ////////////////////////////

  void setupControls()
  {
    // create controls here

    println("Error : setupControls() must be implemented in extended classes ");
  }

  void setGUIValues()
  {
    // overload it to refines all values to controls

    println("Error : setGUIValues() must be implemented in extended classes ");
  }

  // update UI for all non controller (labels or hide/show)
  void update_ui()
  {
    // update all changes in data to controller thats are not user imputs
    // like labels
    // or show hide controls depending on a status

    println("Error : update_ui() must be implemented in extended classes ");
  }

  void draw()
  {
    // can be optionnally setup to draw figure in the drawing
  }

  boolean mousePressed()
  {
    // return true to start a drag
    return false; 
  }

  void mouseDragged()
  {
    // called if drag has started on each mouse move

  }

  void mouseReleased()
  {
    // called if drag has started on mouse up
  }

  //////////////////////////// Association with data changes ////////////////////////////

  public void onUIChanged()
  {
    associated_data.changed = true;
    data.changed = true;
  }

  public void controlEvent(ControlEvent theEvent) {

    String tab_name = "";
    if (theEvent.isController())
    {
      Controller controller = theEvent.getController();
      tab_name = controller.getTab().getName();
    } else if (theEvent.isGroup())
    {
      // used for radio only

      ControllerGroup group = theEvent.getGroup();
      tab_name = group.getTab().getName();

      if (!tab_name.equals(pageName))
        return;

      String class_name = group.getClass().getSimpleName();

      boolean is_radio = class_name.equals("RadioButton");

      if (is_radio)
      {
        // small fix to setup int_value from radio
        int int_value = int(group.getValue());
        String name = group.getName();
        associated_data.setInt(name, int_value);
      }
    }

    if (tab_name == pageName)
      onUIChanged();
  }

  ////////////////// Controls ///////////////////////////

  Textlabel inlineLabel(String content, int width)
  {
    Textlabel l = cp5.addTextlabel("Label" + this.pageName + indexControler)
      .setText(content)
      .setPosition(xPos, yPos)
      .setSize(width, heightCtrl)
      .setColorValue(LabelsHandler.label_color)
      .moveTo(pageName);

    LabelsHandler.labels.add(l);

    xPos += width;
    indexControler++;

    return l;
  }

  Textlabel addLabel(String content)
  {
    yPos += 10;

    Textlabel l = cp5.addTextlabel("Label" + this.pageName + indexControler)
      .setText(content)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)
      .setColorValue(LabelsHandler.label_color)
      .moveTo(pageName);

    LabelsHandler.labels.add(l);

    yPos += 15;
    indexControler++;

    return l;
  }

  Slider addIntSlider(String field, String label, int min, int max)
  {
    return addIntSlider(field, label, associated_data, min, max);
  }

  Slider addIntSlider(String field, String label, Object the_data, int min, int max)
  {
    Slider s = addSlider( field, label, the_data, min, max);
    int nbTicks = (int) (max - min + 1);
    s.setNumberOfTickMarks(nbTicks);
    s.showTickMarks(false);
    s.snapToTickMarks(true);

    return s;
  }

  Slider addSlider(String field, String label, float min, float max)
  {
    return addSlider(field, label, associated_data, min, max);
  }

  int getWidthLabel(String label)
  {

    int width = 0;
    for (char c : label.toCharArray()) {

      switch (c)
      {
      case 'I':
      case 'i':
        width +=2;
        break;

      case 'T':
      case 't':
        width += 4;
        break;
      case '.':
      case ',':
      case ';':
        width += 4;
        break;
      case '-':
        width += 3;
        break;
      default:
        width +=5;
        break;
      }
    }

    return width;
  }

  Slider addSlider(String field, String label, Object the_data, float min, float max)
  {
    Slider s = cp5.addSlider(the_data, field)
      .setLabel(label)
      .setPosition(xPos, yPos)
      .setSize(widthCtrl, heightCtrl)
      .setRange(min, max)
      .moveTo(pageName);

    xPos += xspace + widthCtrl;

    controlP5.Label l = s.getCaptionLabel();
    l.getStyle().marginTop = 0; //move upwards (relative to button size)

    s.getCaptionLabel().getStyle().marginLeft = -getWidthLabel(label) - 8; // adjust -10 as needed


    return s;
  }

  Toggle addToggle(String name, String label)
  {
    Toggle t = cp5.addToggle(associated_data, name)
      .setLabel(label)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)
      .setMode(ControlP5.SWITCH)
      .moveTo(pageName);

    CColor controlerColor = t.getColor();
    int tmp = controlerColor.getActive();
    controlerColor.setActive( controlerColor.getBackground());
    controlerColor.setBackground(tmp);


    xPos+=100+5;

    //t.setLabel("The Toggle Name");
    controlP5.Label l = t.getCaptionLabel();
    l.getStyle().marginTop = -heightCtrl + 2; //move upwards (relative to button size)
    l.getStyle().marginLeft = 10; //move to the right

    return t;
  }

  ColorPicker addColorPicker(String name, String label)
  {
    addLabel(label);

    ColorPicker cp = cp5.addColorPicker(associated_data, name)

      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl*3)
      .moveTo(pageName);

    yPos+=heightCtrl*3;

    return cp;
  }

  ColorGroup addColorGroup(String name, ColorRef colorRef)
  {
    ColorGroup grp = new ColorGroup(colorRef, name );

    grp.Init(this);

    return grp;
  }

  Button addButton(String name)
  {
    int width_bt = 100;

    Button bt = cp5.addButton(name + indexControler)
      .setPosition(xPos, yPos)
      .setLabel(name)
      .setSize(width_bt, heightCtrl)
      .moveTo(pageName);

    xPos += width_bt+5;

    indexControler++;
    return bt;
  }

  RadioButton addRadio(String name, ArrayList<String> labels )
  {
    int width_bt = 100;

    RadioButton r1 = cp5.addRadioButton(associated_data, name)
      .setPosition(xPos, yPos)
      .setSize(width_bt, heightCtrl)
      .setItemsPerRow(labels.size())
      .setSpacingColumn(10)
      .moveTo(pageName);


    for (int i = 0; i < labels.size(); i++)
    {
      String _label = labels.get(i);
      r1.addItem(_label, float(i));
    }

    for (Toggle t : r1.getItems()) {
      t.getCaptionLabel().setColorBackground(color(125, 0));

      t.getCaptionLabel().getStyle().moveMargin(-8, 0, 0, -width_bt);
      t.getCaptionLabel().getStyle().movePadding(7, 0, 0, 3);
      t.getCaptionLabel().getStyle().backgroundWidth = 500;
      t.getCaptionLabel().getStyle().backgroundHeight = 20;
    }

    nextLine();
    return r1;
  }

  void start()
  {
    xPos = 20;
    yPos = 20;
  }

  void nextLine()
  {
    xPos = 20;
    yPos += heightCtrl + 1;
  }

  void space()
  {
    yPos += 5;
  }
}
