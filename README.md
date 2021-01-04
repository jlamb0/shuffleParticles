# shuffleParticles
A script for randomizing locations of objects in a binary image for use as a random control in co-localization analyses

This code was originally developed as a matlab script which took as input a list of point coordinates that represented the outlines of objects automatically defined from binarized images in ImageJ. These locations were then scrambled iteratively, disallowing positions that would place objects outside the edge of the image and avoiding collisions between objects. The output of this code is a list of object outline coordinates and a binary image showing these outlined objects for use as a randomized control in particle co-localization analyses.

The source code for this script was originally published as the matlab function "jl_randomizeParticlesForOscar.m" as supplemental material for Vivas et al. (2017) "Proximal clustering between BK and CaV1.3 channels promotes functional coupling and BK channel activation at low voltage", eLife 2017;6:e28029 DOI: 10.7554/eLife.28029. Updates to the code will be maintained here.

Initial development of this code was supported by a grant from the NIH (NIH R01 NS062436).

Please contact Jason at jtlambert@ucdavis.edu with any questions.
