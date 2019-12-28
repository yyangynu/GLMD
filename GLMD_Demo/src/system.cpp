// System dependent routines
// File: system.cpp


void seedRandom(unsigned int seed)
// seed for random number generator.
{
  srand(seed);
  return;   
}
	      
double random(void)
// random number between 0.0 and 1.0 (uncluded).
{
  double rrr;
  
  rrr = (double) rand() / (double) RAND_MAX;
  return rrr;
}
 
double seconds()
// cpu time in seconds since start of run.
{
  double secs;
   
  secs = (double)(clock() / 1000.0);
  return(secs);
}

