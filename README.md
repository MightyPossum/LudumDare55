# LudumDare55
We make a game


Some post jam findings and thoughts
* Check the profiler and visual profiler
* Test the game on a lower end system. Emulate a computer
* Add an FPS counter
to _process(delta) or similar, add to UI if needed
```
    var fps = Engine.get_frames_per_second()
    print(fps)
```	
* Add occlusion to minimize rendering

* Manually handle everything running through _physics_process() or _process()
	To make sure nothing is running unnecessarily or without being managed and controlled.

* Fix all warnings before building. In Editor warnings can cause larger issues in exported version

