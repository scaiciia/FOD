
Program Ejercicio1;

Type 
    archivo =   file Of Integer;

Procedure cargar (Var a: archivo);

Var 
    num:   Integer;
Begin
    Rewrite(a);
    WriteLn('Ingrese un numero');
    ReadLn(num);
    While (num <> 30000) Do
        Begin
            write(a, num);
            WriteLn('Ingrese un nuevo numero. 30000 para salir');
            ReadLn(num);
        End;
    Close(a);
End;

Var 
    a:   archivo;
    nom:   String[20];

begin
    WriteLn('Ingrese el nombre del archivo');
    ReadLn(nom);
    Assign(a, nom);
    cargar(a);
end.
