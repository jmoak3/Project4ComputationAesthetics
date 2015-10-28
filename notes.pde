// tools to build a song, to draw its notes, and to advance the time-line when the song is played

int nn = 256; // number of notes
float [] T = new float[nn]; // starting times of notes 4 units per seconds
float [] D = new float[nn]; // durations
float [] S = new float[nn]; // semitone )1/12 of octave)
int n=0; // number of notes in song
float songLength=10, totalDuration=0; 

// to add notes to a song 
float tm=4; // conversion ratio for time and duration used to simplify parameters to appendNote and assNOte 
// use this to append notes in order (no silence)
void appendNote(float s, float d) {S[n]=s; T[n]=songLength; D[n]=d/tm; n++; songLength+=d/tm; }

float SILENCE=1000;
void appendSilence(float d) {S[n]=SILENCE; T[n]=songLength; D[n]=d/tm; n++; songLength+=d/tm; }
  
// use this to add notes in any order
void addNote(float s, float t, float d) {S[n]=s; T[n]=t/tm; D[n]=d/tm; n++; songLength=max(songLength,(t+d)/tm); }

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
  for(int i=0; i<songLength; i+=1) {
    addNote(-10,i*tm,0.25*tm);
    addNote(-12,i*tm+3,0.1*tm);
    }
  }

// to draw the music sheet  
float x0, y0, dx, dy; // variables for positioning the music sheet
void initSongChart() {dx=width/12; dy=(height-100)/36; x0=20; y0=24*dy;}
  
void drawSong(){  // draws th emusic sheet
   noFill(); 
   strokeWeight(1); stroke(0,0,250); for(int i=-12; i<27; i++) line(x0,y0-dy*i,width-50,y0-dy*i);
   strokeWeight(2); stroke(0,200,0); for(int i=-12; i<27; i+=3) line(x0,y0-dy*i,width-50,y0-dy*i);
   strokeWeight(3); stroke(150,0,9); for(int i=-12; i<27; i+=12) line(x0,y0-dy*i,width-50,y0-dy*i);
   
   noStroke(); fill(200);
   for(int i=0; i<n; i++) drawNote(S[i],T[i],D[i]); 
   
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