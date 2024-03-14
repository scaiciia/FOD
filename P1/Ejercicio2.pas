
Program Ejercicio2;

Type 
    archivo =   file Of Integer;

Procedure leer(Var a: archivo);

Var 
    num:   Integer;
    c1500, sum, total:   Integer;
Begin
    c1500 := 0;
    sum := 0;
    total := 0;
    Reset(a);
    While (Not(Eof(a))) Do
        Begin
            read(a, num);
            Write(num, ' | ');
            sum := sum + num;
            total := total + 1;
            If (num < 1500) Then
                c1500 := c1500 + 1;
        End;
    WriteLn();
    WriteLn('La cantidad de numeros menores a 1500 son: ', c1500);
    WriteLn('El promedio de los numeros ingresado es: ', (sum/total):   7:   2);
End;

Var 
    a:   archivo;
    nom:   String[20];

Begin
    WriteLn('Ingrese el nombre del archivo');
    ReadLn(nom);
    Assign(a, nom);
    Leer(a);
End.
