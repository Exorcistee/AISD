//Уразаев Константин, ПС-22
//Вариант 13.
//13. В файле заданы N упорядоченных по  возрастанию  списков
//целых чисел.  Организовать  в  оперативной  памяти  с  помощью 
//указателей N линейных списков и слить их в общий список (8).

TYPE
  PNode = ^ListNumbers;
  ListNumbers = RECORD         
                  Number: INTEGER;
                  Next: ^ListNumbers;
                END;

VAR
  F: TEXT;
  MergedListNumbers, FirstListNumbers, SecondListNumbers: ^ListNumbers;
  InputFile, NumberString: STRING;
  Number: INTEGER;
  First, S:  BOOLEAN;

PROCEDURE InsertNumber(VAR List: PNode; Number: INTEGER);
VAR
  NewNode, Current: PNode;
BEGIN

  NEW(NewNode);
  NewNode^.Number := Number;
  NewNode^.Next := NIL;
  
  IF (List = NIL) 
  THEN
    BEGIN
      List := NewNode;
    END
  ELSE
    BEGIN
      Current := List;
      WHILE (Current^.Next <> nil)
      DO
        BEGIN
          Current := Current^.Next;
        END;
      NewNode^.Next := Current^.Next;
      Current^.Next := NewNode;
    END;
END;

PROCEDURE Merge(VAR MergeList, List1, List2: PNode);
VAR
  Current, NewNode: PNode;
BEGIN
  
  Current := NIL;

  WHILE (List1 <> NIL) AND (List2 <> NIL) DO
    BEGIN
      NEW(NewNode);
      IF List1^.Number < List2^.Number THEN
        BEGIN
          NewNode^.Number := List1^.Number;
          List1 := List1^.Next;
        END
      ELSE
        BEGIN
          NewNode^.Number := List2^.Number;
          List2 := List2^.Next;
        END;

      NewNode^.Next := NIL;
      IF MergeList = NIL THEN
        MergeList := NewNode
      ELSE
        Current^.Next := NewNode;
      Current := NewNode;
    END;

  WHILE List1 <> NIL DO
    BEGIN
      NEW(NewNode);
      NewNode^.Number := List1^.Number;
      NewNode^.Next := NIL;
      IF MergeList = NIL THEN
        MergeList := NewNode
      ELSE
        Current^.Next := NewNode;
      Current := NewNode;
      List1 := List1^.Next;
    END;

  WHILE List2 <> NIL DO
    BEGIN
      NEW(NewNode);
      NewNode^.Number := List2^.Number;
      NewNode^.Next := NIL;
      IF MergeList = NIL THEN
        MergeList := NewNode
      ELSE
        Current^.Next := NewNode;
      Current := NewNode;
      List2 := List2^.Next;
    END;
END;

PROCEDURE PrintList(List: ^ListNumbers);
BEGIN
  WHILE List <> NIL
  DO
    BEGIN
      WRITE(List^.Number, ' ');
      List := List^.Next;
    end;
  WRITELN;  
END;

PROCEDURE ClearList(VAR List: ^ListNumbers);
VAR
  Curr, NextNode: ^ListNumbers;
BEGIN
  Curr := List;
  WHILE Curr <> NIL 
  DO
    BEGIN
      NextNode := Curr^.Next;
      DISPOSE(Curr);
      Curr := NextNode;
    END;
  List := NIL;
END;


BEGIN
  WHILE InputFile <> '0'
  DO
    BEGIN
      MergedListNumbers := NIL;
      FirstListNumbers := NIL;
      S := FALSE;
      WRITE('Введите имя файла (для выхода введите 0): ');
      READLN(InputFile);
      IF InputFile = '0'
      THEN
        BREAK;
      TRY
        ASSIGN(F, InputFile);
        RESET(F);
      EXCEPT
        WRITELN('Файла не существует');
        CONTINUE
      END;
      First := TRUE;
      WHILE NOT EOF(F) 
      DO
        BEGIN
          NumberString := '';
          SecondListNumbers := NIL;
          READLN(F, NumberString);
          WHILE Length(NumberString) > 0 
          DO
            BEGIN
              IF POS(' ', NumberString) > 0
              THEN
                BEGIN
                  Number := StrToInt(Copy(NumberString, 1, POS(' ', NumberString) - 1));
                  DELETE(NumberString, 1, POS(' ', NumberString))
                END
              ELSE
                BEGIN
                  Number := StrToInt(NumberString);
                  NumberString := ''
                END;
              IF (First = TRUE) AND (S = FALSE)
              THEN
                InsertNumber(FirstListNumbers, Number)
              ELSE
                InsertNumber(SecondListNumbers, Number);
            END;
          IF First = TRUE
          THEN
            BEGIN
              First := FALSE;
            END
          ELSE
            First := TRUE;
          S := TRUE;
          IF (SecondListNumbers <> NIL) = TRUE
          THEN
            BEGIN
              Merge(MergedListNumbers, FirstListNumbers, SecondListNumbers);
              FirstListNumbers := MergedListNumbers;
              ClearList(SecondListNumbers);
              SecondListNumbers := NIL;
              MergedListNumbers := NIL;
            end;
        END;
      CLOSE(F);
      PrintList(FirstListNumbers);
      ClearList(FirstListNumbers);
      ClearList(SecondListNumbers);
      ClearList(MergedListNumbers);
    END
END.
