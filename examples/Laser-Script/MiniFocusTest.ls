//
// MiniFocusTest.ls
//
// Draw a scale of -10..0..+10 focus lines.
//
// (c) 2016, juergen@fabmail.org
// Distribute under GPL-2.0 or ask.
//

scale=2.0
x_off=2.0
y_off=2.0

function move_s(x, y) { move(x*scale+x_off, y*scale+y_off); }
function line_s(x, y) { line(x*scale+x_off, y*scale+y_off); }

function set_mark()
{
  set("power", 5);
  set("speed", 100);	// marking text
}

// hor. focus_test (left hand side)
for (var f = -10; f < 11; f++)
{
  set("focus", f);
  var h = 0; if (f % 5) h += 3;
  move_s(10+f,h); line_s(10+f,7);
}
set("focus", 0);
move_s(2.5-1, 1.5); line_s(2.5+1, 1.5);					// -
move_s(2.5+1.5, 1.5); line_s(2.5,0); line_s(2.5-1.5, 1.5);

for (var i = 1; i < 6; i++)
  {
    move_s(10-i, 0); line_s(10, 3); line_s(10+i, 0); 			// <<<<
  }
move_s(17.5-1, 1.5); line_s(17.5+1, 1.5); move_s(17.5,0.5); line_s(17.5,2.5);	// +
move_s(17.5+1.5, 1.5); line_s(17.5+0, 3); line_s(17.5-1.5, 1.5);

