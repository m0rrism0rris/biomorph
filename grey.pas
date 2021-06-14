{$MODE OBJFPC}
program biomorph;
uses sysUtils, uComplex, math;
const
	PixlWidth: nativeUInt = 2048;
	PixlHeight: nativeUInt = 2048;

	MinReal = -2.0;
	MaxReal = 2.0;
	SclReal = 4.0 / 2048.0; (* (MaxReal - MinReal) / ScreenWidth  *)
	
	MinImag = -2.0;
	MaxImag = 2.0;
	SclImag = 4.0 / 2048.0; (* (MaxReal - MinReal) / ScreenWidth  *)

//	C: complex = (Re: 0.0; Im: 0.0);

function CCube (Z: complex): complex; inline;
begin
	CCube.Re := Z.Re * Z.Re * Z.Re - 3 * Z.Re * Z.Im * Z.Im;
	CCube.Im := 3 * Z.Re * Z.Re * Z.Im - Z.Im * Z.Im * Z.Im 
end;

function FZ (Z: complex): complex; inline;
const
	C: complex = (Re: 0.0; Im: 0.0);
begin
	FZ := CSin (Z) + CSqr(Z) + C;
end;

{$PUSH} {$BOOLEVAL OFF}
function BiomorphA (X, Y: nativeUInt): byte;
var
	Z: complex;
	Iter: nativeUInt;
begin
	Z.Re := X * SclReal + MinReal;
	Z.Im := Y * SclImag + MinImag;
	for Iter := 1 to 50 do begin
		Z := FZ (Z);
		if Z.Re * Z.Re + Z.Im * Z.Im > 100.0 then break;
	end;
	Z.Re := Abs (Z.Re);
	Z.Im := Abs (Z.Im);
	if Z.Re < 10.0 then
		BiomorphA := 127 + Trunc (Z.Re * 12.8)
	else if Z.Im < 10.0 then
		BiomorphA := 128 - Trunc (Z.Im * 12.8)
	else
		BiomorphA := 127;
end;

var
	OutFile: file of byte;
	X, Y: nativeUInt;
	Ch: char;

begin
	Assign (OutFile, '/Users/cy4n/Desktop/frac/biomorph.pgm');
	Rewrite (OutFile);
	for Ch in 'P5 ' + IntToStr (PixlWidth) + ' ' + IntToStr (PixlHeight) + ' 255' + LineEnding do Write (OutFile, Ord (Ch));
	for Y := 1 to PixlHeight do begin
		Write (#13, Y);
		for X := 1 to PixlWidth do Write (OutFile, BiomorphA (X, Y));
	end;
	WriteLn;
end.
{$POP}

(*
int const
_ ScreenHeight = 63,
_ ScreenWidth = 47
float const
_ MinReal := -2.0,
_ MaxReal := 2.0,
_ MinImag := -2.0,
_ MaxImag := 2.0
float const
_ SclReal := (MaxReal - MinReal) / ScreenWidth,
_ SclImag := (MaxImag - MinImag) / ScreenHeight

int function BiomorphA (int X, Y) is
	complex var Z
	
;

*)