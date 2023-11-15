# Load the trajectory and topology
mol load pdb ../homodimer.pdb trr ../repall.trr
set num_frames [molinfo top get numframes]

# Open a file to save the angle values
set file_id [open "angle_output.txt" w]

# Loop through the frames and calculate the angle between domains
for {set frame 0} {$frame < $num_frames} {incr frame} {

    animate goto $frame

    set pi [expr {atan(1) * 4}]

    set domain1 [atomselect top "chain A and (resid 6 to 47)"]
    set domain2 [atomselect top "chain B and (resid 6 to 47)"]
    set domain3 [atomselect top "(chain A or chain B) and (resid 58)"]

    set domain1_com [measure center $domain1 weight mass]
    set domain2_com [measure center $domain2 weight mass]
    set domain3_com [measure center $domain3 weight mass]

    set vec1 [vecsub $domain3_com $domain1_com]
    set vec2 [vecsub $domain3_com $domain2_com]

    set nvec1 [vecnorm $vec1]
    set nvec2 [vecnorm $vec2]

    set costheta [vecdot $nvec1 $nvec2]

    set angle_rad [expr acos($costheta)]
    set angle_deg [expr $angle_rad*(180/$pi)]

    # Print or save the angle for each frame
    puts $file_id "Frame $frame: [format "%.2f" $angle_deg]"

}

#Close the output file
close $file_id
