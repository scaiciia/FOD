
Program ejercicio7;

Uses sysutils;

Type 
    opciones =   0..5;

    novela =   Record
        cod:   Integer;
        nom:   String;
        genero:   String;
        precio:   Real;
    End;

    archivo =   file Of novela;

Procedure importar(Var a: archivo; Var aText: Text);

Var 
    n:   novela;
Begin
    Reset(aText);
    Rewrite(a);
    While (Not(Eof(aText))) Do
        Begin
            ReadLn(aText, n.cod, n.precio, n.genero);
            ReadLn(aText, n.nom);
            n.genero := TrimLeft(n.genero);
            write(a, n);
        End;
    Close(a);
    Close(aText);
End;

Procedure agregarNovela(Var a: archivo; nom: String);

Var 
    n:   novela;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese el codigo de la novela');
            ReadLn(n.cod);
            WriteLn('Ingrese el nombre');
            ReadLn(n.nom);
            WriteLn('Ingrese el genero');
            ReadLn(n.genero);
            WriteLn('Ingrese el precio');
            ReadLn(n.precio);
            Reset(a);
            Seek(a, FileSize(a));
            write(a, n);
            Close(a);
        End;
End;

Procedure modificarNovela(Var a: archivo; nom: String);

Var 
    n:   novela;
    aux:   Integer;
    encontrado:   Boolean;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese el nombre de la novela a modificar');
            ReadLn(aux);
            encontrado := False;
            Reset(a);
            While ((Not(Eof(a))) And (Not(encontrado))) Do
                Begin
                    Read(a, n);
                    If (n.cod = aux) Then
                        encontrado := True;
                End;
            If (encontrado) Then
                Begin
                    WriteLn('Ingrese el nombre de la novela');
                    ReadLn(n.nom);
                    WriteLn('Ingrese el genero');
                    ReadLn(n.genero);
                    WriteLn('Ingrese el precio');
                    ReadLn(n.precio);
                    Seek(a, FilePos(a) - 1);
                    write(a, n);
                End
            Else
                WriteLn('El codigo ingresado no fue encontrado');
            Close(a);
        End;
End;

Procedure mostrarDatos(Var a: archivo; nom: String);

Var 
    n:   novela;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    Read(a, n);
                    WriteLn('Codigo: ', n.cod, ' - Precio: $', n.precio:6:2, ' - Genero: ', n.genero);
                    WriteLn('Nombre: ', n.nom);
                    WriteLn();
                End;
            Close(a);
        End;
End;

Procedure exportar(Var a: archivo; nom: String; Var aText: Text);

Var 
    n:   novela;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Rewrite(aText);
            While (Not(Eof(a))) Do
                Begin
                    Read(a, n);
                    WriteLn(aText, n.cod, ' ', n.precio:6:2, ' ', n.genero);
                    WriteLn(aText, n.nom);
                End;
            Close(aText);
            Close(a);
        End;
End;

Var 
    a:   archivo;
    aText:   Text;
    rta:   opciones;
    nom:   String;
    fin:   Boolean;

Begin
    WriteLn('Ingrese el nombre del archivo');
    ReadLn(nom);
    Assign(a, nom);
    Assign(aText, 'novelas.txt');
    fin := False;
    Repeat
        WriteLn('1. Importar');
        WriteLn('2. Agregar novela');
        WriteLn('3. Modificar novela');
        WriteLn('4. Mostrar datos');
        WriteLn('5. Exportar');
        WriteLn('0. Salir');
        WriteLn();
        Write('--> ');
        ReadLn(rta);
        Case rta Of 
            0:   fin := True;
            1:   importar(a, aText);
            2:   agregarNovela(a, nom);
            3:   modificarNovela(a, nom);
            4:   mostrarDatos(a, nom);
            5:   exportar(a, nom, aText)
                 Else
                     WriteLn('Opcion incorrecta. Intente nuevamente');
        End;
    Until (fin);
End.
