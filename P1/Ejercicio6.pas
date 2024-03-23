
Program Ejercicio6;

Uses sysutils;

Type 
    opciones =   0..7;

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
                    c.desc := TrimLeft(c.desc);
                    c.marca := TrimLeft(c.marca);
                    Write(a, c);
                End;
            Close(a);
            Close(celulares);
        End;
End;

Procedure imprimir(c: celular);
Begin
    WriteLn('Codigo: ', c.cod, ' - Precio: $', c.precio:9:2, ' - Marca: ', c.marca);
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
                    WriteLn(celulares, c.cod, ' ', c.precio:9:2, ' ', c.marca);
                    WriteLn(celulares, c.stockDisp, ' ', c.stockMin, ' ', c.desc);
                    WriteLn(celulares, c.nom);
                End;
            Close(celulares);
            Close(a);
        End;
End;

Procedure agregarCelular(Var a: archivo; nom: String);

Var 
    c:   celular;
    rta:   char;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Seek(a, FileSize(a));
            Repeat
                WriteLn('Ingrese el codigo');
                ReadLn(c.cod);
                WriteLn('Ingrese nombre');
                ReadLn(c.nom);
                WriteLn('Ingrese descripcion');
                ReadLn(c.desc);
                WriteLn('Ingrese marca');
                ReadLn(c.marca);
                WriteLn('Ingrese el precio');
                ReadLn(c.precio);
                WriteLn('Ingrese el stock minimo');
                ReadLn(c.stockMin);
                WriteLn('Ingrese el stock disponible');
                ReadLn(c.stockDisp);
                Write(a, c);
                WriteLn('Desea ingresar otro equipo? (S/N)');
                ReadLn(rta);
            Until ((rta = 'N') Or (rta = 'n'));
            Close(a);
        End;
End;

Procedure modificarStock(Var a: archivo; nom: String);

Var 
    buscar:   String;
    c:   celular;
    encontrado:   Boolean;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese el nombre del celular a buscar');
            ReadLn(buscar);
            encontrado := false;
            Reset(a);
            While ((Not(Eof(a))) And (Not(encontrado))) Do
                Begin
                    read(a, c);
                    If (c.nom = buscar) Then
                        encontrado := True;
                End;
            If (encontrado) Then
                Begin
                    WriteLn('Ingrese el nuevo stock');
                    ReadLn(c.stockDisp);
                    Seek(a, FilePos(a)-1);
                    Write(a, c);
                End
            Else
                WriteLn('No se encontro el equipo');
            Close(a);
        End;
End;

Procedure exportarSinStock(Var a: archivo; nom: String; Var sinStock: Text);

Var 
    c:   celular;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Rewrite(sinStock);
            While (Not(Eof(a))) Do
                Begin
                    read(a, c);
                    If (c.stockDisp = 0) Then
                        Begin
                            WriteLn(sinStock, c.cod, ' ', c.precio:9:2, ' ', c.marca);
                            WriteLn(sinStock, c.stockDisp, ' ', c.stockMin, ' ', c.desc);
                            WriteLn(sinStock, c.nom);
                        End;
                End;
            Close(a);
            Close(sinStock);
        End;
End;

Var 
    a:   archivo;
    celulares, sinStock:   Text;
    nom:   String;
    salir:   Boolean;
    rta:   opciones;

Begin
    WriteLn('Ingrese el nombre del archivo');
    ReadLn(nom);
    Assign(celulares, 'celulares.txt');
    Assign(sinStock, 'SinStock.txt');
    Assign(a, nom);
    salir := false;
    Repeat
        WriteLn('1. Generar archivo.');
        WriteLn('2. Listar celulares menores al stock minimo.');
        WriteLn('3. Listar celulares con descripcion determinada.');
        WriteLn('4. Exportar archivo.');
        WriteLn('5. Agregar celular');
        WriteLn('6. Modificar stock');
        WriteLn('7. Exportar sin stock');
        WriteLn('0. Salir.');
        WriteLn();
        Write('--> ');
        ReadLn(rta);
        Case rta Of 
            1:   generarArchivo(a, celulares);
            2:   listarStockMinimo(a, nom);
            3:   listarDescripcion(a, nom);
            4:   exportarArchivo(a, nom, celulares);
            5:   agregarCelular(a, nom);
            6:   modificarStock(a, nom);
            7:   exportarSinStock(a, nom, sinStock);
            Else
                salir := true;
        End;
    Until (salir);
End.
