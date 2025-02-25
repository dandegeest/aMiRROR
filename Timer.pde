@FunctionalInterface
interface TimerFunction {
    void timeout(Timer timer);
}

class Timer {
  int interval = 1 * 1000; // 1 Second Timer Interval
  int lastFire = 0;
  TimerFunction tfx;
  
  void start(int timeout) {
    interval = timeout;
    lastFire = millis();
  }
  
  void stop() {
    interval = 0;
  }
}

void timer(Timer t) {
  if (t.interval == 0)
    return;
    
  // Check if the specified interval has passed
  if (millis() - t.lastFire > t.interval) {
    t.lastFire = millis();
    t.tfx.timeout(t);
  }
}
