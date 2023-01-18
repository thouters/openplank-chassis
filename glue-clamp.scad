touch_pcb_y = 100;
pcb_border=1;

clamped_y = touch_pcb_y+2*pcb_border;
clamp_jaw_width=10;
clamp_jaw_z=5;

base_z = 5;
cube([15, clamped_y + 2*clamp_jaw_width,base_z]);

cube([15, clamp_jaw_width, base_z+clamp_jaw_z]);
translate([0,clamped_y+clamp_jaw_width,0])
    cube([15, clamp_jaw_width, base_z+clamp_jaw_z]);

