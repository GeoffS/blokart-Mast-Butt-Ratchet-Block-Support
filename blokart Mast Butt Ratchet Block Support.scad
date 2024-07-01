include <../OpenScadDesigns/MakeInclude.scad>
use <../OpenScadDesigns/torus.scad>

/* build_fa = 20;
build_fs = 1.5; */

build_fa = 15;
build_fs = 1.5;

mastButtOD = 40.6;

minkowskiDia = 4;

ropeDia = 7;

ropeSupportDia = ropeDia + 5;
echo(str("ropeSupportDia = ", ropeSupportDia));

nominalClipZ = 25;
echo(str("nominalClipZ = ", nominalClipZ));
nominalClipPosY = 10;
nominalRopeOffsetZ = ropeDia/2;
nominalRopeZ = nominalClipZ + nominalRopeOffsetZ;

clipBottomTrimZ = minkowskiDia/2 * 0.15;
echo(str("clipBottomTrimZ = ", clipBottomTrimZ));
clipZ = nominalClipZ - minkowskiDia + clipBottomTrimZ;
ropeZ = nominalRopeZ - minkowskiDia/2 + clipBottomTrimZ;
clipPosY = nominalClipPosY - minkowskiDia/2;

dia = mastButtOD + minkowskiDia - 1;
echo(str("dia = ", dia));
t = 0.01;

rr = ropeDia/2 + minkowskiDia/2;
echo(str("rr = ", rr));

bottomOffsetZ = minkowskiDia/2-clipBottomTrimZ;
echo(str("bottomOffsetZ = ", bottomOffsetZ));

ropeChannelRadius = dia/2+t/2+rr - 4;
echo(str("ropeChannelRadius = ", ropeChannelRadius));

module skeleton()
{
  difference()
  {
    // The "positive" part of the support:
    translate([0,0,bottomOffsetZ])
    {
      // The OD of the clip:
      cylinder(d=dia+t/2, h=clipZ);

      // The bump:
      at = 30;
      act = 60;
      acb = 60;
      hull()
      {
        translate([0, 0, ropeZ])
          rotate(-90-at/2, [0,0,1])
            torus2b(ropeSupportDia/2, ropeChannelRadius, at);
        difference()
        {
          translate([0,0,clipZ]) cylinder(d=dia+t/2, h=1);
          rotate(-90+act/2, [0,0,1]) tc([-100, 0, -100], 200);
          rotate(-180-act/2, [0,0,1]) tc([0, -100, -100], 200);
        }
        difference()
        {
          cylinder(d=dia+t/2, h=1);
          rotate(-90+acb/2, [0,0,1]) tc([-100, 0, -100], 200);
          rotate(-180-acb/2, [0,0,1]) tc([0, -100, -100], 200);
        }
      }
    }

    // The subtractions from the above:
    translate([0,0,bottomOffsetZ])
    {
      // Trim the top/aft part of the rope support:
      // This is for a full clip:
      //translate([0, 0, ropeZ]) cylinder(d=dia+1, h=100);
      // This is for an open-top half-clip:
      translate([-50, -100, ropeZ]) cube([100, 100, 100]);

      // Trim the opening for the rope:
      translate([0,0,ropeZ]) hull() torus2b(rr, ropeChannelRadius, 360);
    }

    // Trim the mast-OD:
    translate([0,0,-1]) cylinder(d=dia-t/2, h=100);

    // Trim off the back of the clip:
    tc([-200, clipPosY, -200], 400);

    // Trim below the cylinder:
    tc([-200,-200,-400+bottomOffsetZ], 400);
  }
}

module itemModule(expand)
{
  difference()
  {
    expand(expand, minkowskiDia)
    {
      skeleton();
    }
    // Trim below Z=0:
    tc([-200,-200,-400], 400);
  }
}

module clip()
{
	//tc([-200, -400, -10], 400);

  // Clip +X:
  //tc([0, -200, -10], 400);

  // Clip above rope center:
  //tc([-200, -200, clipZ/2], 400);
}

if(developmentRender)
{
	difference()
	{
		itemModule(true);
		clip();
	}
  //ropeGhost();
  //mastGhost();
}
else
{
	rotate(180, [0,0,1]) itemModule(true);
}

module ropeGhost()
{
  ropeDia = 4.7;
  ropeRadius = ropeDia/2;
  %translate([0,0,nominalRopeZ]) rotate(270/2, [0,0,1]) torus2b(ropeRadius, mastButtOD/2+ropeRadius, 270);
}

module mastGhost()
{
  %translate([0,0,-40]) cylinder(d=mastButtOD, h=100);
}
