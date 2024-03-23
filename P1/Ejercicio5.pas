
Program Ejercicio5;

Uses sysutils;

Type 
    opciones =   0..4;

    celular =   Record
        cod:   Integer;
        nom:   String;
        desc:   String;
        marca:   String;
        precio:   Real;
        stockMin:   Integer;
        stockDisp:   Integer;
    End;

    archivo =   file Of celular;

Procedure generarArchivo(Var a: archivo; Var celulares: Text);

Var 
    c:   celular;
Begin
    If (FileExists('celulares.txt')) Then
        Begin
            Rewrite(a);
            Reset(celulares);
            While (Not(Eof(celulares))) Do
                Begin
                    ReadLn(celulares, c.cod, c.precio, c.marca);
                    ReadLn(celulares, c.stockDisp, c.stockMin, c.desc);
                    ReadLn(celulares, c.nom);
                    c.marca := TrimLeft(c.marca);
                    c.desc := TrimLeft(c.desc);
                    write(a, c);
                End;
            Close(a);
            Close(celulares);
        End;
End;

Procedure imprimir(c: celular);
Begin
    WriteLn('Codigo: ', c.cod, ' - Precio: $', c.precio:7:2, ' - Marca: ', c.marca);
    WriteLn('Stock disponible: ', c.stockDisp, ' - Stock minimo: ', c.stockMin, ' - Descripcion: ', c.desc);
    WriteLn('Nombre: ', c.nom);
    WriteLn();
End;

Procedure listarStockMinimo(Var a: archivo; nom: String);

Var 
    c:   celular;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    read(a, c);
                    If (c.stockDisp < c.stockMin) Then
                        Begin
                            imprimir(c);
                        End;
                End;
            Close(a);
        End;
End;

Procedure listarDescripcion(Var a: archivo; nom: String);

Var 
    c:   celular;
    desc:   String;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese la descripcion a buscar');
            ReadLn(desc);
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    read(a, c);
                    If (desc = c.desc) Then
                        Begin
                            imprimir(c);
                        End;
                End;
            Close(a);
        End;
End;

Procedure exportarArchivo(Var a: archivo; nom: String; Var celulares: Text);

Var 
    c:   celular;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Rewrite(celulares);
            While (Not(Eof(a))) Do
                Begin
                    read(a, c);
                    WriteLn(celulares, c.cod, ' ', c.precio:7:2, ' ', c.marca);
                    WriteLn(celulares, c.stockDisp, ' ', c.stockMin, ' ', c.desc);
                    WriteLn(celulares, c.nom);
                End;
            Close(celulares);
            Close(a);
        End;
End;

Var 
    a:   archivo;
    celulares:   Text;
    nom:   String;
    salir:   Boolean;
    rta:   opciones;

Begin
    WriteLn('Ingrese el nombre del archivo');
    ReadLn(nom);
    Assign(celulares, 'celulares.txt');
    Assign(a, nom);
    salir := false;
    Repeat
        WriteLn('1. Generar archivo.');
        WriteLn('2. Listar celulares menores al stock minimo.');
        WriteLn('3. Listar celulares con descripcion determinada.');
        WriteLn('4. Exportar archivo.');
        WriteLn('0. Salir.');
        WriteLn();
        Write('--> ');
        ReadLn(rta);
        Case rta Of 
            1:   generarArchivo(a, celulares);
            2:   listarStockMinimo(a, nom);
            3:   listarDescripcion(a, nom);
            4:   exportarArchivo(a, nom, celulares);
            Else
                salir := true;
        End;
    Until (salir);
End.
