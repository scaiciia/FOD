
Program Ejercicio4;

Uses sysutils;

Type 
    opciones =   0..8;
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

Procedure agregarEmpleados(Var a: archivo; Var id: Integer; nom: String);

Var 
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Seek(a, FileSize(a)-1);
            read(a, e);
            id := e.ID;
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
            Close(a)
            ;
        End;
End;

Procedure modificarEdad(Var a: archivo; nom: String);

Var 
    ID:   Integer;
    e:   empleado;
    fin:   Boolean;
Begin
    If (FileExists(nom)) Then
        Begin
            WriteLn('Ingrese el numero de empleado');
            ReadLn(ID);
            Reset(a);
            fin := false;
            While ((Not(Eof(a))) And (Not(fin))) Do
                Begin
                    read(a, e);
                    If (e.ID = ID) Then
                        Begin
                            WriteLn('Ingrese la nueva edad');
                            ReadLn(e.edad);
                            Seek(a, filePos(a)-1);
                            write(a, e);
                        End;
                End;
            close(a);
        End;
End;

Procedure exportar(Var a: archivo; nom: String; Var aTodos: Text);

Var 
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Rewrite(aTodos);
            While (Not(eof(a))) Do
                Begin
                    read(a, e);
                    WriteLn(aTodos, ' ', e.ID, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
                End;
            close(a);
            close(aTodos);
        End;
End;

Procedure exportarDNIFaltantes(Var a: archivo; nom: String; Var aFaltaDNI: Text);

Var 
    e:   empleado;
Begin
    If (FileExists(nom)) Then
        Begin
            Reset(a);
            Rewrite(aFaltaDNI);
            While (Not(Eof(a))) Do
                Begin
                    read(a, e);
                    If (e.DNI = '00') Then
                        WriteLn(aFaltaDNI, ' ', e.ID, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
                End;
            Close(aFaltaDNI);
            Close(a);
        End;
End;

Var 
    a:   archivo;
    rta:   opciones;
    salir:   Boolean;
    nom:   String;
    id:   Integer;
    aTodos, aFaltaDNI:   Text;

Begin
    WriteLn('Ingrese nombre del archivo');
    ReadLn(nom);
    Assign(a, nom);
    Assign(aTodos, 'todos_empleados.txt');
    Assign(aFaltaDNI, 'faltaDNIEmpleado.txt');
    salir := False;
    id := 0;
    Repeat
        WriteLn('      1. Crear archivo.');
        WriteLn('      2. Buscar empleado.');
        WriteLn('      3. Listar empleados.');
        WriteLn('      4. Proximos a jubilarse.');
        WriteLn('      5. Agregar empleados.');
        WriteLn('      6. Modificar edad empleado.');
        WriteLn('      7. Exportar');
        WriteLn('      8. Exportar DNI faltantes');
        WriteLn('      0. Salir');
        Writeln();
        Write('--> ');
        ReadLn(rta);
        Case rta Of 
            1:   crearArchivo(a, id, nom);
            2:   buscarEmpleado(a, nom);
            3:   listarEmpleados(a, nom);
            4:   proximasJubilaciones(a, nom);
            5:   agregarEmpleados(a, id, nom);
            6:   modificarEdad(a, nom);
            7:   exportar(a, nom, aTodos);
            8:   exportarDNIFaltantes(a, nom, aFaltaDNI)
                 Else
                     salir := True
        End;
    Until (salir = True);
End.
