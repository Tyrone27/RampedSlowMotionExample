# RampedSlowMotionExample


This simple example demonstrates a ramped SlowMotion effect in Swift 3.0 

Traditional slow motion looks like this 


<img src = "https://i.stack.imgur.com/WAiJW.png"  >  

The "|_|" in the middle shows the timeRange in slowMotion . As can be seen , transition from normal to slow is abrupt.

To smoothen the slow motion effect this timeRange can be EASED in and out of the normal speed so that it looks like this 

<img src = "https://i.stack.imgur.com/TqRm4.png"  >

This parabolic effect causes the ramp. 

Within the  <span style = "background= color : #C0C0C0" > AssetConfig </span>  class , the <b>downWithRamp(...)</b> method allows for this to happen.


<b> ISSUES </b> : 

There is however an arbitrary blank ramped segment within the video when exported. You will understand when you run the project for yourself.

