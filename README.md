# Determining-the-intracellular-position

How to use the imageJ macro and R script to produced normalized distance profile graph normalized in X and Y from 0 to 1 : 

![shema ](./doc/shema.png)

1) Install the plugin "radial profile NN.class" in Fiji/plugin.
The plugin radial profile (https://imagej.nih.gov/ij/plugins/radial-profile.html) was modified to produce a non normalized radial profile

2) Run the Fiji macro "radial_profile_version3.ijm" on the different images (use the czi file) 
 ![confocal image ](./doc/KD SKIP Overexpression of K3.jpg)

3) Run the script named "Radial Profiles_normalisation_0to1.R" for each experiment containing 20 radial profiles to produce  normalized profiles in X  between 0 to 1 for each profile

4) Run "Mean Profile_09a2021_KO_overlay.R" and "Mean Profile_09a2021_WT_overlay.R" to produce the pool profile for WT1,2,3 and KO1,2,3 with the smooth profile (loess method) and the confidence interval

5) You will obtain the two curves WT and KO graph

![WT versus KO radial distance to nucleus ](./doc/Normalized_radial_profile.png)
