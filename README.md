# RampedSlowMotionExample


This example demonstrates a ramped SlowMotion effect in Swift 3.0 

Traditional slow motion looks like this 
----|____|----  

The "|_|" in the middle shows the timeRange in slowMotion . As can be seen , transition from normal to slow is abrupt.

To smoothen the slow motion effect this timeRange can be EASED in and out of the normal speed so that it looks like this 

---U---

This parabolic effect causes the ramp. 

Within the AssetConfig file, the <b>downWithRamp(...)</b> method allows for this to happen.
