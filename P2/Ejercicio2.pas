program Ejercicio2;

const
    valorBajo = -1;

type
    carreraAlumno = record
        cod: Integer;
        apellido: String;
        nombre: String;
        cantCursadas: Integer;
        cantFinales: Integer;
    end;

    opciones = 0..1;
    materiaAlumno = record
        cod: Integer;
        cursadaFinal: opciones;
    end;

    maestro = file of carreraAlumno;
    detalle = file of materiaAlumno;

procedure leer(var d: detalle; var ma: materiaAlumno);
    begin
        if (not(eof(d))) then
            read(d, ma)
        else
            ma.cod:= valorBajo;
    end;

procedure recorrer(var m: maestro; var d: detalle);
    var
        auxd: materiaAlumno;
        auxm: carreraAlumno;
    begin
        reset(m);
        reset(d);
        leer(d, auxd);
        while(auxd.cod <> valorBajo) do begin
            read(m, auxm);
            while (auxd.cod = auxm.cod) do begin
                if (auxd.cursadaFinal = 0) then
                    auxm.cantCursadas:= auxm.cantCursadas + 1
                else begin
                    auxm.cantFinales:= auxm.cantFinales + 1;
                    auxm.cantCursadas:= auxm.cantCursadas - 1;
                end;
                leer(d, auxd);
            end;
            seek(m, (filePos(m) - 1));
            write(m, auxm);
        end;
    end;

procedure imprimirArchivo(var m: maestro; var t: text);
    var
        auxm: carreraAlumno;
    begin
        reset(m);
        rewrite(t);
        while (not(eof(m))) do begin
            read(m, auxm);
            if (auxm.cantFinales > auxm.cantCursadas) then
                writeln(t, 'Codigo: ', auxm.cod, ' - Nombre y Apellido: ', auxm.nombre, ' ', auxm.apellido, ' - Cursadas: ', auxm.cantCursadas, ' - Finales: ', auxm.cantFinales);
        end;
    end;

var
    m: maestro;
    d: detalle;
    t: text;

begin
    assign(m, 'archivoAlumnos');
    assign(d, 'archivoMateria');
    assign(t, 'masFinalesQCursadas.txt');
    recorrer(m, d);
    imprimirArchivo(m, t);
end.
