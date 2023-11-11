//Уразаев Константин, ПС-22
//Вариант 14.
//В некоторых строках текстового файла имеются выражения,
//состоящие   из   двух   целых   чисел,   разделенных    знаком
//арифметической   операции ('+','-','*','/'). Первое  из  чисел
//может быть отрицательным. В строке может содержаться несколько
//выражений. Перед  выражением  и  после него  могут  находиться
//произвольные символы. Требуется  выделить  строку,  в  которой
//значение выражения максимально. Вывести найденное максимальное
//значение (7).
FUNCTION GetInt(Number: STRING): REAL;
  VAR
    L, I, Num, Ten, Finish: INTEGER;
    Minus: BOOLEAN;
  BEGIN
    Num := 0;
    Ten := 1;
    IF Number[1] = '-'
    THEN
      Minus := TRUE
    ELSE
      Minus := FALSE;
    IF Minus = TRUE
    THEN
      Finish := 2
    ELSE
      Finish := 1;
    FOR L := LENGTH(Number) DOWNTO Finish
    DO
      BEGIN
        Ten := 1;
        FOR I := 1 TO (LENGTH(Number) - L)
        DO
          Ten := 10 * Ten;  
        Num := Num + ((Ord(Number[L]) - 48) * Ten)
      END;
    IF Minus = TRUE
    THEN
      GetInt := Num * -1
    ELSE
      GetInt := Num
  END;

VAR
  F: TEXT;
  I, J, MaxString, CurString : INTEGER;
  Max, Sum: REAL;
  S, Str, Number, Number1, Number2, InputFile: STRING;
  Sign: CHAR;
BEGIN
  READLN(InputFile);
  TRY 
    ASSIGN(F, InputFile);
    RESET(F);
  EXCEPT
    BEGIN
      WRITELN('Файл не существует');
      EXIT
    END
  END;  
  Max := 0;
  Number1 := '';
  Number2 := '';
  I := 1;
  MaxString := 1;
  CurString := 1;
  WHILE NOT EOF(F)
  DO
    BEGIN
      I := 1;
      READLN(F, S);
      WHILE I < LENGTH(S)
      DO
        BEGIN
          Str := '';
          Number := '';
          Number1 := '';
          Number2 := '';
          WHILE (I < Length(S))
          DO
            BEGIN
              IF (S[I] = '-') AND (I > 1)
              THEN
                IF (S[I - 1] IN ['0'..'9']) AND (S[I + 1] IN ['0'..'9'])
                THEN
                  BREAK
                ELSE
                  BEGIN
                    Str := Str + S[I];
                    I := I + 1;
                    CONTINUE
                  END
              ELSE
                IF (S[I] = '-')
                THEN
                  BEGIN
                    Str := Str + S[I];
                    I := I + 1;
                    CONTINUE;
                  END
                ELSE
                  IF (S[I] IN ['*', '+', '/']) AND (I > 1)
                  THEN
                    BEGIN
                      IF S[I + 1] IN ['0'..'9']
                      THEN
                        BEGIN
                          BREAK;
                        END
                      ELSE
                        Str := Str + S[I];
                        I := I + 1;
                        CONTINUE
                    END
                  ELSE
                    BEGIN
                      Str := Str + S[I];
                      I := I + 1
                    END
            END;
          CASE S[I] OF
              '+': Sign := '+';
              '-': Sign := '-'; 
              '*': Sign := '*';
              '/': Sign := '/'
            END;
          I := I + 1;  
          J := LENGTH(Str);
          WHILE (Str[J] IN ['0'..'9']) AND (J >= 1)
          DO
            BEGIN
              Number := Number + Str[J];
              IF J = 1
              THEN
                BREAK;
              J := J - 1; 
            END;
          IF Str[J] = '-'
          THEN
            Number := Number + S[J];
          FOR J := LENGTH(Number) DOWNTO 1
          DO
            Number1 := Number1 + Number[J];
          WHILE (S[I] IN ['0'..'9']) AND (I <= LENGTH(S))
          DO
            BEGIN
              Number2 := Number2 + S[I];
              IF I = LENGTH(S)
              THEN
                BREAK;
              I := I + 1;
            END;
          CASE Sign OF
            '+': Sum := GetInt(Number1) + GetInt(Number2);
            '-': Sum := GetInt(Number1) - GetInt(Number2); 
            '*': Sum := GetInt(Number1) * GetInt(Number2);
            '/': Sum := GetInt(Number1) / GetInt(Number2);  
          END;
          IF Max < Sum 
          THEN
            BEGIN
              Max := Sum;
              MaxString := CurString;
            END;
          WHILE (S[I] NOT IN ['-', '0'..'9']) AND (I < LENGTH(S))
          DO
            BEGIN
              I := I + 1;
            END;
        END;    
        CurString := CurString + 1;  
      END;
   WRITELN('Максимальное число - ', Max);
   WRITELN('Его строка - ', MaxString);
END.