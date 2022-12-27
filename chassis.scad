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
led_z = 2.8;
base_obj_z = 10;

plug_width = 10;
plug_z = 5;
module ledmatrix()
{
    cube([led_x,led_y,2.8]);

}
module touchpcb()
{
    cube([touch_pcb_x,touch_pcb_y,pcb_thickness]);
}

module bottom_left_plug_aperture()
{
    translate([matrix_border_width, matrix_border_width, led_z])
        plug_aperture(plug_z, plug_width, angle=45);
}
module top_left_plug_aperture()
{
    translate([matrix_border_width,matrix_border_width + led_y, led_z])
        plug_aperture(plug_z, plug_width, angle=-45);
}
module bottom_right_plug_aperture()
{
    translate([matrix_border_width + led_x, matrix_border_width, led_z])
        plug_aperture(plug_z, plug_width, angle=90+45);
}
module top_right_plug_aperture()
{
    translate([matrix_border_width + led_x,matrix_border_width + led_y, led_z])
        plug_aperture(plug_z, plug_width, angle=-90-45);
}

module chassis(number_of_panels=1)
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
                    touch_pcb_y+2*pcb_border,
                    base_obj_z+pcb_thickness
                ]);
                // mill out pcb
                translate([0,0,-pcb_thickness])
                    cube([touch_pcb_x,touch_pcb_y,pcb_thickness]);

                // led matrix
                led_z_cutout = 20;
                translate([matrix_border_width,matrix_border_width,0])
                    cube([led_x,led_y,led_z_cutout]);

            {
                // pinheader opening top right
                translate([94,90+1,0])
                    cube([35,10-1,20]);
                // pinheader opening bottom left
                translate([30,0,0])
                    cube([34,10-1,20]);
            }

                bottom_left_plug_aperture();
                top_left_plug_aperture();

                translate([matrix_border_width,matrix_border_width,0])
                    cylinder(20,d=2);
                translate([matrix_border_width,matrix_border_width+led_y,0])
                    cylinder(20,d=2);
                translate([matrix_border_width+led_x,matrix_border_width,0])
                    cylinder(20,d=2);

                translate([matrix_border_width+led_x,matrix_border_width+led_y,0])
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


        if (number_of_panels == 1)
        {
            bottom_right_plug_aperture();
            top_right_plug_aperture();
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
    }
}
module one_assembly(number_of_panels)
{

    for(i=[0:number_of_panels-1])
    {
        translate([-pcb_border, -pcb_border, -pcb_thickness])
        translate([(i>0?i+1:0)*170,(i>0?100:0),0])
        rotate([0,0,(i>0?1:0)*180])
        {
 //           color("green")
//            touchpcb();
            color("red")
            linear_extrude(height = 15)
            translate([touch_pcb_x/2,touch_pcb_y/2,0])
            mirror([1,0,0])
            translate([-touch_pcb_x/2,-touch_pcb_y/2,0])

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


module plug(plug_z, plug_d,solid=0)
{
    difference()
    {
        cylinder(plug_z, d=plug_d, $fn=80);
        if (solid != 1)
        {
            cylinder(10,d=2.5,$fn=80);
        }
    }
}

module plug_aperture(plug_z, plug_d, angle=45)
{
    plug(plug_z, plug_d,solid=1);
        rotate([0,0,angle])
    translate([plug_d/2, 0, plug_z/2])
        cube([plug_d, plug_d, plug_z], center=true);

}

if(1)
{
//    one_assembly(1);
    chassis(1);
}
else
{

    difference()
    {

        union()
        {
            color("red")
            {
            cube([10,20,10]);
            cube([20,10,10]);
            }
        }
    translate([10,10,plug_z/2+2.5])
    {
    //plug_aperture(45,15);
    }

    }
   translate([30,10,2.5])
        plug();
    dove(dove_d,10);
}
