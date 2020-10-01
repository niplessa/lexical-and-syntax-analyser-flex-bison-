program try_it;
const g= 0x1a61; gg= -0x65c02;
type ar= array[1..g] of integer;
     ar1= array[1..g] of { no comment
at all! } real;
     gar= -g..g;
     arre1 = array[gar] of re1;
     day = (monday,tuesday,friday);
     day_list = array[1..g] of day;
     day_array = array[monday..tuesday] of char;
var x,y: ar; xx: ar1; z,w: real; r: re;
    i,j,k: integer; b: arre1;
    c: day_array; cc: day_list;
    s1,s2,s3: string;
function try_me(i,j:integer): boolean; forward;
procedure _all(n:integer; var x: real);
   function try_me(i,j:integer): real;
   const omega='W'; int=g div 2;
   procedure nested(var i:integer);
      var k:integer;
      begin
      if xx[i] >= 0.0 then k := 1 else k := 2;
      x := x + k;
      i := k
      end;
   begin
   nested(k);
   c[tuesday] := '\n';
   s := cc[monday, tuesday];
   if (i+j > int) then try_me :=0.0
   else
      if (i > int) then try_me :=-1.0
      else try_me := 1.0;
   cc := length("monday");
   cc := cc+length("friday");
   if cc < g then s1 := "string1";
   end;
begin
if (n <= 0) then
   x := 1.0 {{ or x := -1.0}
else
   begin
   _all(try_me(n-1,y[n+1]),x);
   x := -x
   end
end;
function try_me;
begin
try_me := i = j;
end;
procedure kkk;
begin
write("Reached procedure kkk");
end;
begin
b[r_x1] := not (x[r_x1] > x[r_x2]) and not try_me(0xA10,x[j]) or (z = k*3);
c[monday] := '\t';
while z do
   begin
   _all(-y[x[r_x1]],xx[y[x[r_x2]]]);
   while b[x[r_x2]] do
      if (b and (r_x1 > y[r_x1 mod k])) then kkk;
   z := r_x1 div k;
   end;
s2 := s1+"23";
for i := x[y[g]] downto 1 do
   read(x[i],j,y[j]);
y := x;
while b[i] do
   b := not b or (r_x2 = 0);
write("endofprogram")
end.
