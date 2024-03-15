
Program Ejercicio3;

Uses sysutils;

Type 
    opciones =   0..4;
    empleado =   Record
        ID:   Integer;
        apellido:   String[30];
        nombre:   String[30];
        edad:   Integer;
        DNI:   String[8];
    End;

    archivo =   file Of empleado;

Procedure ingresarDatos(Var e: empleado; id: Integer);

Begin
    e.ID := id;
    WriteLn('Ingrese nombre del empleado');
    ReadLn(e.nombre);
    WriteLn('Ingrese la edad');
    ReadLn(e.edad);
    WriteLn('Ingrese el DNI del empleado');
    ReadLn(e.DNI);
End;

Procedure crearArchivo(Var a: archivo; Var id: Integer; nom: String);

Var 
    rta:   char;
    sigue:   Boolean;
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Se perdera toda la informacion. Desea continuar? (S/N)');
            ReadLn(rta);
            If ((rta = 'S') Or (rta = 's')) Then
                sigue := True
            Else
                sigue := False;
        End
    Else
        sigue := True;
    If (sigue) Then
        Begin
            Rewrite(a);
            WriteLn('Ingrese apellido del empleado');
            ReadLn(e.apellido);
            While (e.apellido <> 'fin') Do
                Begin
                    id := id + 1;
                    ingresarDatos(e, id);
                    Write(a, e);
                    WriteLn('Ingrese apellido del empleado. Ingrese "fin" para Salir');
                    ReadLn(e.apellido);
                End;
            close(a);
        End;
End;

Procedure imprimir(e: empleado);

Begin
    WriteLn('   ID :', e.ID);
    WriteLn('       Apellido: ', e.apellido);
    WriteLn('       Nombre: ', e.nombre);
    WriteLn('       Edad: ', e.edad);
    WriteLn('       DNI: ', e.DNI);
End;

Procedure buscarEmpleado(Var a: archivo; nom: String);

Var 
    buscar:   String[30];
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese el nombre/apellido a buscar');
            ReadLn(buscar);
            WriteLn('Resultados:');
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    read(a, e);
                    If ((e.apellido = buscar) Or (e.nombre = buscar)) Then
                        Begin
                            imprimir(e);
                        End;
                End;
            close(a);
        End;
End;

Procedure listarEmpleados(Var a: archivo; nom: String);

Var 
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Empleados:');
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    Read(a, e);
                    WriteLn('   ID: ', e.ID, ' - Apellido: ', e.apellido, ' - Nombre: ', e.nombre, ' - Edad: ', e.edad, ' - DNI: ', e.DNI);
                End;
            Close(a);
        End;
End;

Procedure proximasJubilaciones(Var a: archivo; nom: String);

Var 
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Proximos Jubilados:');
            Reset(a);
            While (Not(Eof(a))) Do
                Begin
                    Read(a, e);
                    If (e.edad > 70) Then
                        Begin
                            imprimir(e);
                        End;
                End;
            Close(a);
        End;
End;

Var 
    a:   archivo;
    rta:   opciones;
    salir:   Boolean;
    nom:   String;
    id:   Integer;

Begin
    WriteLn('Ingrese nombre del archivo');
    ReadLn(nom);
    Assign(a, nom);
    salir := False;
    id := 0;
    Repeat
        WriteLn('      1. Crear archivo.');
        WriteLn('      2. Buscar empleado.');
        WriteLn('      3. Listar empleados.');
        WriteLn('      4. Proximos a jubilarse');
        WriteLn('      0. Salir');
        ReadLn(rta);
        Case rta Of 
            1:   crearArchivo(a, id, nom);
            2:   buscarEmpleado(a, nom);
            3:   listarEmpleados(a, nom);
            4:   proximasJubilaciones(a, nom)
                 Else
                     salir := True
        End;
    Until (salir = True);
End.
