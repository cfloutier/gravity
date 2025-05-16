// trace particles lines

/*  
* 
* This is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
* 
* http://creativecommons.org/licenses/LGPL/2.1/
* 
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
* 
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

import controlP5.*;
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;

DataGlobal global_data;
DataGUI dataGui;

ParticlesGenerator generator;

//SourceFiles sourceFilesGui;
PGraphics current_graphics;

ControlP5 cp5;

void setup() 
{ 
    size(1200, 800); 
    
    global_data = new DataGlobal();
    dataGui = new DataGUI(global_data);
    
    generator = new ParticlesGenerator(global_data.particles);
    
      
    setupControls();
    
    global_data.LoadSettings("./Settings/default.json");
    global_data.name = "default";
    
    dataGui.setGUIValues();
    
    surface.setResizable(true);
}

void setupControls()
{ 
    cp5 = new ControlP5(this); 
    cp5.getTab("default").setLabel("Hide GUI");
    
    addFileTab();
    dataGui.setupControls();     
}

void draw()
{
    start_draw();  
  
    background(global_data.style.backgroundColor.col);
    
    if (global_data.particles.changed)
      generator.buildLines();   
    
    // recenter
    pushMatrix();
    translate(width/2, height/2);
    
    strokeWeight(global_data.style.lineWidth);   
    stroke(global_data.style.lineColor.col);
      
    smooth();
    generator.draw();

    popMatrix();
    end_draw();

    global_data.particles.changed = false;
}
