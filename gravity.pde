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

GravityData data;
DataGUI dataGui;

ParticlesGenerator generator;

//SourceFiles sourceFilesGui;
PGraphics current_graphics;

ControlP5 cp5;

void setup() 
{ 
    size(1200, 800); 
    
    data = new GravityData();
    dataGui = new DataGUI(data);
    
    generator = new ParticlesGenerator(data);

    setupControls();
    
    data.LoadSettings("./Settings/default.json");
    
    dataGui.setGUIValues();
    
    surface.setResizable(true);
}

void setupControls()
{ 
    cp5 = new ControlP5(this); 
    cp5.getTab("default").setLabel("Hide GUI");
    
    // special tab
    addFileTab();
    dataGui.Init();
}

void draw()
{
    start_draw();  
  
    background(data.style.backgroundColor.col);
    
   // if (data.any_change())
      generator.buildLines();   
    
    // recenter
    pushMatrix();
    translate(width/2, height/2);
    scale(data.global_scale,data.global_scale);
    
    strokeWeight(data.style.lineWidth);   
    stroke(data.style.lineColor.col);
      
    smooth();

    generator.draw();
    // adds UI draws
    dataGui.draw();

    popMatrix();
    end_draw();

    data.particles.changed = false;
}

