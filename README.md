# Objective: Approximate volume of drops in image taken under a Scanning Electron Microsocpe (SEM)
The objective was to detect and approximate the volume of drops in a Pipette/Test Tube image, taken under a Scanning Electron Microsocpe (SEM). The source was a research problem for a PostGrad Student/friend in Chemical Engineering Department, UTP.
The Matlab code does the following:
- Detects and idendifies drops in the SEM image
- Draws a boundary of the drops detected with centers
- Approximates the volume assuming its a cylindrical drop
- Developed and tested on Matlab 2016.

 ### Command line arguments: ###
 -p : image path (optional)
 -t : threshold value (optional)

 ### Result Window: ###
 
![Results_Window](https://i.imgur.com/T0jUVwV.png)

### Results table (Displayed on console): ###

![Result_Output](https://i.imgur.com/3nxdZZD.jpg)
