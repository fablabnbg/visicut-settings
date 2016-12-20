//
// PowerSpeedTest.ls
//
// Draw a row of rectangles, and adjacent text (from a 7 segment font)
// ramping up power from 5 to 100 %, then ramping down speed from 100 to 5%
//
// (c) 2016, juergen@fabmail.org
// Distribute under GPL-2.0 or ask.
//

scale=1/1.5
x_off=2.0
y_off=2.0

// use twolines_break=0 to render all in one line.
twolines_break=152
twolines_stride=28

      // 0  1  2  3  4  5  6
      // --------------------
s7__ = [ 0, 0, 0, 0, 0, 0, 0 ]
s7_0 = [ 1, 1, 0, 1, 1, 1, 1 ]
s7_1 = [ 0, 1, 0, 1, 0, 0, 0 ]
s7_2 = [ 1, 1, 1, 0, 1, 1, 0 ]
s7_3 = [ 1, 1, 1, 1, 1, 0, 0 ]
s7_4 = [ 0, 1, 1, 1, 0, 0, 1 ]
s7_5 = [ 1, 0, 1, 1, 1, 0, 1 ]
s7_6 = [ 0, 0, 1, 1, 1, 1, 1 ]
s7_7 = [ 1, 1, 0, 1, 0, 0, 0 ]
s7_8 = [ 1, 1, 1, 1, 1, 1, 1 ]
s7_9 = [ 1, 1, 1, 1, 0, 0, 1 ]
s7_A = [ 1, 1, 1, 1, 0, 1, 1 ]
s7_C = [ 1, 0, 0, 0, 1, 1, 1 ]
s7_E = [ 1, 0, 1, 0, 1, 1, 1 ]
s7_F = [ 1, 0, 1, 0, 0, 1, 1 ]
s7_J = [ 0, 1, 0, 1, 1, 1, 0 ]	// L+J => W
s7_L = [ 0, 0, 0, 0, 1, 1, 1 ]
s7_P = [ 1, 1, 1, 0, 0, 5, 1 ]
s7_U = [ 0, 1, 0, 1, 1, 1, 1 ]
s7_D  = s7_0
s7_R  = s7_A
s7_S  = s7_5
s7_O  = s7_0

// segment order
//   0
// 6   1
//   2
// 5   3
//   4

pow = [   5,  10,  15,  20,  30,  40,  50,  60,  70,  80,  90, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 ]
spe = [ 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,  90,  80,  70,  60,  50,  40,  30,  20,  15,  10,   5 ]

pow_text = [ s7__, s7__, s7_5, s7__, 
             s7__, s7_1, s7_0, s7__,
             s7__, s7_1, s7_5, s7__,
             s7__, s7_2, s7_0, s7__,
	     s7__, s7_3, s7_0, s7__,
	     s7__, s7_4, s7_0, s7__,
	     s7__, s7_5, s7_0, s7__,
	     s7__, s7_6, s7_0, s7__,
	     s7__, s7_7, s7_0, s7__,
	     s7__, s7_8, s7_0, s7__,
	     s7__, s7_9, s7_0, s7__,

	     s7_1, s7_0, s7_0, s7__,

	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__ ]

spe_text = [ s7_1, s7_0, s7_0, s7__,
             s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,
	     s7_1, s7_0, s7_0, s7__,

	     s7_1, s7_0, s7_0, s7__,

	     s7__, s7_9, s7_0, s7__,
	     s7__, s7_8, s7_0, s7__,
	     s7__, s7_7, s7_0, s7__,
	     s7__, s7_6, s7_0, s7__,
	     s7__, s7_5, s7_0, s7__,
	     s7__, s7_4, s7_0, s7__,
	     s7__, s7_3, s7_0, s7__,
	     s7__, s7_2, s7_0, s7__,
	     s7__, s7_1, s7_5, s7__,
	     s7__, s7_1, s7_0, s7__,
	     s7__, s7__, s7_5, s7__ ]

if (twolines_break)
  {
    function move_s(x, y) 
      {
        if (x > twolines_break)
           move((x-twolines_break)*scale+x_off, (y+twolines_stride)*scale+y_off); 
	else
           move(x*scale+x_off, y*scale+y_off);
      }
    function line_s(x, y) 
      { 
        if (x > twolines_break)
           line((x-twolines_break)*scale+x_off, (y+twolines_stride)*scale+y_off); 
	else
           line(x*scale+x_off, y*scale+y_off);
      }
  }
else
  {
    function move_s(x, y) { move(x*scale+x_off, y*scale+y_off); }
    function line_s(x, y) { line(x*scale+x_off, y*scale+y_off); }
  }

// top left corner is 0,0.
function seg7(x, y, w, h, a)
{
  if (a[0]) { move_s(x,  y);       line_s(x+w,y); }
  if (a[1]) { move_s(x+w,y);       line_s(x+w,y+0.5*h); }
  if (a[2]) { move_s(x,  y+0.5*h); line_s(x+w,y+0.5*h); }
  if (a[3]) { move_s(x+w,y+0.5*h); line_s(x+w,y+h); }
  if (a[4]) { move_s(x,  y+h);     line_s(x+w,y+h); }
  if (a[5]) { move_s(x,  y+0.5*h); line_s(x,  y+h); }
  if (a[6]) { move_s(x,  y);       line_s(x,  y+0.5*h); }
}

function rect(x, y, width, height)
{
	move_s(x, y);
	line_s(x+width, y);
	line_s(x+width, y+height);
	line_s(x, y+height);
	line_s(x, y);
}

function set_mark()
{
  set("power", 5);
  set("speed", 100);	// marking text
}

// start of code execution here.

// the border rectangle is without prior seting of speed or power
// this makes the settings of the cut dialog effective for the border.
if (twolines_break)
  {
    xend = (2*x_off + 1*twolines_break  + 3 ) * scale;
    yend = (2*y_off + 2*twolines_stride - 2 ) * scale;
  }
else
  {
    xend = (2*x_off + 304               + 3 ) * scale;
    yend = (2*y_off + 1*twolines_stride - 2 ) * scale;
  }
move(0,0); 
line(xend, 0);
line(xend, yend); 
line(0,    yend); 
line(0,0);

set_mark();
seg7(0,0,  3,5, s7_P);	// POWER
seg7(4,0,  3,5, s7_O);
seg7(8,0,  3,5, s7_L);
seg7(11,0, 3,5, s7_J);
// seg7(15,0, 3,5, s7_E);	// ugly
// seg7(19,0, 3,5, s7_R);	// ugly

seg7(0,7,  3,5, s7_S);	// SPEED
seg7(4,7,  3,5, s7_P);
seg7(8,7,  3,5, s7_E);
seg7(12,7, 3,5, s7_E);
// seg7(16,7, 3,5, s7_D);	// ugly

// hor. focus_test (left hand side)
for (var f = -10; f < 11; f++)
{
  set("focus", f);
  var h = 14; if (f % 5) h += 3;
  move_s(10+f,h); line_s(10+f,20);
}
set("focus", 0);
move_s(2.5-1, 14+1); line_s(2.5+1, 14+1);					// -
line_s(2.5, 14+2.5); line_s(2.5-1, 14+1);

move_s(10-1, 22+0); line_s(10, 22-2); line_s(10+1, 22+0);		// ^

move_s(17.5-1, 14+1); line_s(17.5+1, 14+1); move_s(17.5,14+0); line_s(17.5,14+2);	// +
move_s(17.5+1, 14+1); line_s(17.5+0, 14-.5); line_s(17.5-1, 14+1);

seg7( 0,21, 2,3, s7_F);
seg7( 3,21, 2,3, s7_O);
seg7( 6,21, 2,3, s7_C);
seg7(12,21, 2,3, s7_U);
seg7(15,21, 2,3, s7_S);

// squares and percentage values
for (var i = 0; i < 23; i++)
{
	set_mark();
	for (var j = 0; j < 4; j++)
	  {
	    seg7(19+12*i+4*j, 0, 3, 5, pow_text[4*i+j]);
	    seg7(19+12*i+4*j, 7, 3, 5, spe_text[4*i+j]);
	  }
	set("power", pow[i]);
	set("speed", spe[i]);
	rect(21+12*i, 14, 10, 10);
}


// vert. focus_test (right hand side)
set_mark();
var xr = 21+23*12
for (var f = -10; f < 11; f++)
{
  set("focus", f);
  var h = xr; if (f % 5) h += 3;
  move_s(h,10+f); line_s(xr+6,10+f);
}
set("focus", 0);
move_s(xr+8, 5-1); line_s(xr+8,5+1);					// -
move_s(xr+9, 10-2); line_s(xr+6, 10); line_s(xr+9,10+2);		// <
move_s(xr+8, 15-1); line_s(xr+8, 15+1); move_s(xr+7,15); line_s(xr+9,15); // +

