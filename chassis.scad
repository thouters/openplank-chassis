//$fn=100;

pcb_border=1;
pcb_thickness=0.6;
dove_d=7;
dove_h=20;

touch_pcb_x = 170;
touch_pcb_y = 100;
matrix_border_width = 10;
led_x = 160;
led_y = 80;
module ledmatrix()
{
    cube([led_x,led_y,2.8]);

}
module touchpcb()
{
    cube([touch_pcb_x,touch_pcb_y,pcb_thickness]);
}

module chassis(number_of_panels=1)
{
    {
    difference()
    {
        union()
        {
            difference()
            {
            color("blue")

                // z offset base object to mill out pcb
                translate([-pcb_border, -pcb_border, -pcb_thickness])
                // base object
                cube([
                    ((number_of_panels == 1)?touch_pcb_x+10:touch_pcb_x)+pcb_border,
                    touch_pcb_y+pcb_border,
                    10+pcb_thickness
                ]);
                // mill out pcb
                translate([0,0,-pcb_thickness])
                    cube([touch_pcb_x,touch_pcb_y,pcb_thickness]);

                // led matrix
                led_z_cutout = 20;
                translate([matrix_border_width,matrix_border_width,0])
                    cube([led_x,led_y,led_z_cutout]);

                // pinheader opening top left
                translate([40,90-2,0])
                cube([35,10-1,20]);
                // pinheader opening bottom right
                translate([107,2,0])
                cube([34,10-1,20]);

                // openings for z clamps
                for(y=[10-5,90-5])
                {
                translate([10-5,y,2.8])
                    cube([10,10,10]);
                }

                // clear out corners
                translate([10,10,0])
                    cylinder(20,d=2);
                translate([10,90,0])
                    cylinder(20,d=2);

                if (number_of_panels > 1)
                {
                    asymetry_length = 30;
                    // creating asymetry: short end
                    translate([
                        led_x + matrix_border_width -asymetry_length,
                        90,
                        0
                    ])
                        cube([30,10,20]);
                    translate([
                        led_x + matrix_border_width-asymetry_length,
                        led_y +matrix_border_width,
                        0
                    ])
                    translate([0,5,0])
                        dove(dove_d,dove_h);
                }


            }
            color("red")
            {
                if (number_of_panels > 1)
                {
                    // creating asymetry; extended end
                    translate([led_x + matrix_border_width,0,0])
                    difference()
                    {
                        cube([asymetry_length,10,10]);
                        translate([asymetry_length,5,0])
                        dove(dove_d,dove_h);
                    }
                }
            }
        }
        translate([170-5,5,2.8])
            cube([10,10,10]);

        if (number_of_panels == 1)
        {
            translate([170-5,90-5,2.8])
               cube([10,10,10]);
       }

    }
    }
}
module one_assembly(number_of_panels)
{

    for(i=[0:number_of_panels-1])
    {
        translate([(i>0?i+1:0)*170,(i>0?100:0),0])
        rotate([0,0,(i>0?1:0)*180])
        {
            color("green")
            touchpcb();
            color("red")
            linear_extrude(height = 15)
            import("pcb-touch-simple-B_Mask-connectors.svg");

            color("white")
            translate([0,0,-0.1])
            linear_extrude(height = 0.2)
            import("pcb-touch-simple-F_Cu.svg");
        }

        translate([10,10,0.6])
        translate([(i)*160,0,0])
        ledmatrix();
    }

    translate([0,0,0.6])
    for(i=[0:number_of_panels-1])
    {
       translate([2*i*170,i*100,0])
       rotate([0,0,i*180])

       chassis(number_of_panels);
    }
}


module dove(d=5,height=10)
{
    for(i=[0:1])
    {
        mirror([i,0,0])
       translate([-d/4,0,0])
                cylinder(height,d=d,$fn=3);
    }
    translate([0,0,height/2])
    cube([d/2,3,height],center=true);
}

if(1)
{
//    one_assembly(1);
    chassis(1);
}
else
{
    dove(dove_d,10);
}
