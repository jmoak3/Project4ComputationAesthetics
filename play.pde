import ddf.minim.*;
import ddf.minim.ugens.*;
// tools for playing music
Minim minim;
AudioOutput out;
AudioRecorder recorder;
float F00=220.0; // base frequency. Use F00=344.53;  to synchronize with plot

boolean playing=false;


void startOrStopPlaying() {
    if(playing) {playing=false; out.close();} 
    else {
      playing=true;  
      out = minim.getLineOut(Minim.MONO,1024*16); 
      playPhrase();
      }  
  }

void playPhrase(){
   totalDuration=0;
   playFrameCounter=0;
   out.pauseNotes(); // do not play yet, first put all notes into the play buffer to help synchronization
   for(int i=0; i<n; i++) 
     if(S[i]!=SILENCE)
     {
       note(T[i],D[i],Fofs(C[3*i]));
       note(T[i],D[i],Fofs(C[3*i+1]));
       note(T[i],D[i],Fofs(C[3*i+2]));
     }
       //note(T[i],D[i],Fofs(S[i])); // converts S[i] from semitone to frequency
   out.resumeNotes(); // play now
   }
   
void note(float start, float duration, float freq){ // adds a note to the play buffer
   out.playNote(start,duration,freq); 
   totalDuration=max(totalDuration,start+duration);
   }

float Fofs(float semitone) {return F00*pow(2.0,semitone/12.0);} // returns frequency of semitone (which is pitch/12)