{$MODE OBJFPC}
program biomorph;
uses sysUtils, uComplex, math;
const
	PixlWidth: nativeUInt = 512;
	PixlHeight: nativeUInt = 512;

	MinReal = -5.0;
	MaxReal = 5.0;
	SclReal = 10.0 / 512.0; (* (MaxReal - MinReal) / ScreenWidth *)
	
	MinImag = -5.0;
	MaxImag = 5.0;
	SclImag = 10.0 / 512.0; (* (MaxReal - MinReal) / ScreenWidth *)

function FZ (Z: complex): complex; inline;
const
	C: complex = (Re: 0.5; Im: 0.5);
begin
	FZ := Z * Z + C;
end;

function Biomorph (X, Y: nativeUInt): boolean;
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
	{$PUSH} {$BOOLEVAL OFF}
	if (Abs (Z.Re) < 10.0) or (Abs (Z.Im) < 10.0) then
		Biomorph := True
	else
		Biomorph := False
	{$POP}
end;

var
	OutFile: file of byte;
	X, Y: nativeUInt;
	Byt: byte;
	Ch: char;

begin
	Assign (OutFile, 'biomorph.pbm');
	Rewrite (OutFile);
	for Ch in 'P4 ' + IntToStr (PixlWidth) + ' ' + IntToStr (PixlHeight) + LineEnding do Write (OutFile, Ord (Ch));
	for Y := 0 to PixlHeight-1 do begin
		Write (#13, Y);
		X := 0;
		while X < PixlWidth do begin
			Byt := Ord (Biomorph (X, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+1, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+2, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+3, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+4, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+5, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+6, Y));
			Byt := (Byt shl 1) + Ord (Biomorph (X+7, Y));
			X := X + 8;
			Write (OutFile, Byt);
		end;
	end;
	WriteLn;
end.
