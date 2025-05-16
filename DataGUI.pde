import controlP5.*;  

class DataGUI
{
   public DataGUI(DataGlobal data)
  {
    this.data = data;
    particles_ui = new ParticlesGUI(data.particles); 
    style_gui = new StyleGUI(); 
  }

  DataGlobal data;
  ParticlesGUI particles_ui;
  StyleGUI style_gui;
  
  // update UI for all non controller (labels or hide/show)
  void update_ui()
  {
    if (!data.changed && !data.need_update_ui )
      return;

    particles_ui.update_ui();  
    style_gui.update_ui();  
  }
  
  void setupControls()
  { 
    particles_ui.setupControls(  ) ;
    style_gui.setupControls();  
    cp5.getTab("Particles").bringToFront();
  }
  
  void setGUIValues()
  {
    particles_ui.setGUIValues();
    style_gui.setGUIValues();
  }
}
