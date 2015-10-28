// tools to build a song, to draw its notes, and to advance the time-line when the song is played
color black=#000000, white=#FFFFFF, // set more colors using Menu >  Tools > Color Selector
   red=#FF0000, green=#00FF01, blue=#0300FF, yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, grey=#5F5F5F, brown=#AF6407,
   sand=#FCBA69, pink=#FF8EE7 ;
int nn = 256; // number of notes
float [] T = new float[nn]; // starting times of notes 4 units per seconds
float [] D = new float[nn]; // durations
float [] S = new float[nn]; // semitone )1/12 of octave)
float [] C = new float[3*nn]; // Triads to replace notes

//Data structure for lookup table for semitone to frequency conversion
float [] JS = new float[13]; // Array to hold ratio values for Fundamental Just Scale
float [] ETS = new float[13]; // Array to hold ratio values for Equitempered Scale

int n=0; // number of notes in song
float songLength=10, totalDuration=0; 

// to add notes to a song 
float tm=4; // conversion ratio for time and duration used to simplify parameters to appendNote and assNOte 
// use this to append notes in order (no silence)
void appendNote(float s, float d) {S[n]=s; addChords(n,s); T[n]=songLength; D[n]=d/tm; n++; songLength+=d/tm; }

float SILENCE=1000;
void appendSilence(float d) {S[n]=SILENCE; T[n]=songLength; D[n]=d/tm; n++; songLength+=d/tm; }
  
// use this to add notes in any order
void addNote(float s, float t, float d) {S[n]=s; addChords(n,s); T[n]=t/tm; D[n]=d/tm; n++; songLength=max(songLength,(t+d)/tm); }
 
//Adds a triad to replace the note with the average pitch over the 3 notes of the triad being equalt to the pitch of the original note
void addChords(int n, float s)
{ 
  //Major
  float b = 0, c = 0;
  if (Chord == 0) {b = 4; c = 7;}
  if (Chord == 1) {b = 3; c = 7;}
  if (Chord == 2) {b = 3; c = 6;}
  float root = s - (b+c)/3.0;//4.0/5.0 * s;
  C[3*n] = root;
  C[3*n+1] = root + b;//1.12246 * root;//5.0/4.0 * root;
  C[3*n+2] = root + c;//1.49831 * root;//3.0/2.0 * root;
}

//Function to initiate the JS and ETS arrays with prepopulated chord mapping ratios
void initConvScales()
{
  //Just Scale
  JS[0] = 1.0000;  //Unison
  JS[1]  = 1.0417;  //Minor Second
  JS[2]  = 1.1250;  //Major Second
  JS[3]  = 1.2000;  //Minor Third
  JS[4]  = 1.2500;  //Major Third
  JS[5]  = 1.3333;  //Fourth
  JS[6]  = 1.4063;  //Diminshed Fifth
  JS[7]  = 1.5000;  //Fifth
  JS[8]  = 1.6000;  //Minor Sixth
  JS[9]  = 1.6667;  //Major Sixth
  JS[10]  = 1.8000;  //Minor Seventh
  JS[11]  = 1.8750;  //Major Seventh
  JS[12]  = 2.0000;  //Octave
  
  //Equitempered Scale
  ETS[0] = 1.0000;  //Unison
  ETS[1]  = 1.05946;  //Minor Second
  ETS[2]  = 1.12246;  //Major Second
  ETS[3]  = 1.18921;  //Minor Third
  ETS[4]  = 1.25992;  //Major Third
  ETS[5]  = 1.33483;  //Fourth
  ETS[6]  = 1.41421;  //Diminshed Fifth
  ETS[7]  = 1.49831;  //Fifth
  ETS[8]  = 1.58740;  //Minor Sixth
  ETS[9]  = 1.68179;  //Major Sixth
  ETS[10]  = 1.78180;  //Minor Seventh
  ETS[11]  = 1.88775;  //Major Seventh
  ETS[12]  = 2.0000;  //Octave
}

// to make a song
void initSong() { // from Jobim's Desafinado
  songLength=0; 
  n=0;
  appendSilence(4); // silence
  appendSilence(1); // silence
  appendNote(1,2); 
  appendNote(2,1);
  appendNote(4,2);
  appendNote(5,2);
  appendNote(4,3);
  appendNote(2,1);
  appendNote(1,2);
  appendNote(2,2);
  appendNote(5,3);
  appendNote(1,1);
  appendNote(1,12);
  }

void loadSong(String fn) {
  songLength=0; 
  n=0;
  println("loading: "+fn); 
  String [] ss = loadStrings(fn);
  int comma1, comma2; int nv; float a, b, c;
  nv = ss.length;
  println(nv);
  for(int i=0; i<nv; i++) {
    comma1=ss[i].indexOf(',');   
    comma2=ss[i].indexOf(',', comma1+1);   
    a=float(ss[i].substring(0, comma1));
    b=float(ss[i].substring(comma1+1, comma2));
    c=float(ss[i].substring(comma2+1, ss[i].length()));
    addNote(b,a,c);
    };
  };


// to add a beat to the current song
void addBeat() {  // to call AFTER initiSong or compose because it uses songLength that is set by these
  //for(int i=0; i<songLength; i+=1) {
  //  addNote(-10,i*tm,0.25*tm);
  //  addNote(-12,i*tm+3,0.1*tm);
  //  }
  }

// to draw the music sheet  
float x0, y0, dx, dy; // variables for positioning the music sheet
void initSongChart() {dx=width/12; dy=(height-100)/36; x0=20; y0=24*dy;}
  
void drawSong(){  // draws th emusic sheet
   noFill(); 
   strokeWeight(1); stroke(0,0,250); for(int i=-12; i<27; i++) line(x0,y0-dy*i,width-50,y0-dy*i);
   strokeWeight(2); stroke(0,200,0); for(int i=-12; i<27; i+=3) line(x0,y0-dy*i,width-50,y0-dy*i);
   strokeWeight(3); stroke(150,0,9); for(int i=-12; i<27; i+=12) line(x0,y0-dy*i,width-50,y0-dy*i);
   
   noStroke(); 
   for(int i=0; i<n; i++)
   {
     fill(yellow);
     drawNote(C[3*i],T[i],D[i]);
     fill(red);
     drawNote(C[3*i+1],T[i],D[i]);
     fill(green);
     drawNote(C[3*i+2],T[i],D[i]);
   }
   //drawNote(S[i],T[i],D[i]); 
   
   strokeWeight(1); stroke(0); for(float i=0; i<20; i+=1./tm) line(x0+i*dx,0,x0+i*dx,dy*36);
   strokeWeight(3); stroke(0); for(float i=0; i<20; i+=1.) line(x0+i*dx,0,x0+i*dx,dy*36);
   }
   
void drawNote(float s, float t, float d) {if(s!=SILENCE) rect(x0+t*dx+2,y0-s*dy-3,d*dx-4,-dy+6);}  

// to draw the red time-line
int playFrameCounter=0; // to drive the red line
void drawTimeLine(){
  strokeWeight(1); stroke(255,0,0); 
  float t=(-5.+playFrameCounter)/30; // -5 corrects for delay in frames before starting the song
  line(x0+t*dx,0,x0+t*dx,dy*36);
  }