//*****************************************************************************
// Base code for the Music Project for Computational Aesthetics
// Author Jarek Rossignac
// Last updated: June 22, 2015
// Functionality
// plays a song (press SPACE)
// saves a .wav file of the song and the image of the music sheet (press '/')
// let's the user edit the endpoints of the orange diagonal (hold '1' or '2' and drag the mouse)
// generates a equisempled pitch ramp (press 'c')
//
// STUDENTS OROJECT:
// TEAM MEMBERS: James Moak, Deep Ghosh
//     edit function 'compose' in tab 'phrase'
//*****************************************************************************

PImage just, equit, happy, sad, augmented;
vec v;
pts E = new pts();
String mus;
pts F = new pts();
int Chord, Scale;
void setup() {             
  textureMode(NORMAL);
   size(1200,1000, P3D);      
   just = loadImage("data/just.bmp");
   equit = loadImage("data/equitemp.bmp");
   happy = loadImage("data/happy.bmp");
   sad = loadImage("data/sad.bmp");
   augmented = loadImage("data/curious.bmp");
   mus = "data/music.txt";
   smooth();  strokeJoin(ROUND); strokeCap(ROUND); 
   frameRate(30);
   minim = new Minim(this); // Declares minim which we use for sounds
   initSongChart(); // inits measures for drawing the music sheet
   loadSong(mus);  
   E.declare();
   F.declare();
   
   F.addPt(P(1000,800));
   F.addPt(P(800,800));
  
   E.addPt(P(600,800));
   E.addPt(P(400,800));
   E.addPt(P(200,800));
   v = V(0, -100);
   
   initConvScales();
   } 
 
void draw() {   
  if(snapPic) beginRecord(PDF, PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); // start saving a .pdf of the screen
  background(255); noFill(); 

  drawObject(F.G[0], v, just);
  if (F.pv == 0) {Scale = 0; show(F.G[0], 20);}
  drawObject(F.G[1], v, equit);
  if (F.pv == 1) {Scale = 1; show(F.G[1], 20);}
  drawObject(E.G[0], v, happy);
  if (E.pv == 0) {Chord = 0; show(E.G[0], 20);}
  drawObject(E.G[1], v, sad);
  if (E.pv == 1) {Chord = 1; show(E.G[1], 20);}
  drawObject(E.G[2], v, augmented);
  if (E.pv == 2) {Chord = 2; show(E.G[2], 20);}
  
  if(keyPressed&&key=='1') {to+=(float)(mouseX-pmouseX)/dx; so-=(float)(mouseY-pmouseY)/dy;}
  if(keyPressed&&key=='2') {te+=(float)(mouseX-pmouseX)/dx; se-=(float)(mouseY-pmouseY)/dy;}
  fill(0); text("to="+nf(to,1,2)+", so="+nf(so,1,2)+", te="+nf(te,1,2)+", se="+nf(se,1,2),width-300,height-100); // for precise aligment
  showLine(); // shows the orange diagonal
  
  if (E.pv == 0) Chord = 0;
  if (E.pv == 1) Chord = 1;
  if (E.pv == 2) Chord = 2;
  if (F.pv == 1) isEquitempered = true;
  if (F.pv == 0) isEquitempered = false;
  loadSong(mus);
  
  if(playing) {playFrameCounter++; drawTimeLine();} // advances the red vertical timeline
  
  drawSong(); // draws the sheet with notes
  
  if(playing && recording) saveRecording(); // stops recording and sets playing = false when totalDuration is exceeded

  // enter team memeber names below !!!
  fill(50); text("Computational Aesthetics--Music Project: Interpolating phrase. Student 1, Student 2",10,height-100);
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen
 
 
  // Help text (not showing on print)
  fill(100);
  text("press'1'/'2' and drag to edit diagonal, 'c' to compose, SPACE to play/stop, ` to save .pdf or / to record .wav & .pdf",10,height-20);
  
  }
  
  
void mousePressed() {  // executed when the mouse is pressed
  boolean useF = true;
  for (int i=0;i<E.nv;++i) {
    if (n(V(Mouse(), F.G[0])) > n(V(Mouse(), E.G[i])) &&
        n(V(Mouse(), F.G[1])) > n(V(Mouse(), E.G[i])))
      useF = false;
    }
  if (useF) F.pickClosest(Mouse());
  else      E.pickClosest(Mouse());

  }

void drawObject(pt P, vec V, PImage t) {
  beginShape(); 
    texture(t);
    v(P(P(P,1,V),1,R(V)), 1, 0);
    v(P(P(P,1,V),-1,R(V)), 0, 0);
    v(P(P(P,-1,V),-1,R(V)), 0, 1);
    v(P(P(P,-1,V),1,R(V)), 1, 1); 
  endShape(CLOSE);
  }
  
  