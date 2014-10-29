PROGRAM CalculateAverage;
	
VAR
	sum, count, value: INTEGER;
	average: REAL;
		
BEGIN
	
	sum := 0;
	count := 0;
	ReadLn(value);
	
	WHILE value > 0 DO BEGIN
		sum := sum + value;
		count := count + 1;
		ReadLn(value)
	END;
	
	IF count > 0 THEN
		average := sum / count
	ELSE
		average := 0;	
	;
	Write('Mittelwert: ');
	Write(average:8:2)
	
END.