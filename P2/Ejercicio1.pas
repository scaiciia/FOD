program Ejercicio1;

const
  valorBajo= -1;

type
    empleado = record
        cod: integer;
        nom: String;
        comision: Real;
    end;

    archivo = file of empleado;

procedure leer(var a: archivo; var e: empleado);
  begin
    if (not(eof(a))) then
      read(a, e)
    else
      e.cod:= valorBajo;
  end;

procedure compactar(var a: archivo; var r: archivo);
  var
    e, aux: empleado;
    empAct: Integer;
  begin
    reset(a);
    rewrite(r);
    leer(a, e);
    while (e.cod <> valorBajo) do begin
      empAct:= e.cod;
      aux.cod:= e.cod;
      aux.nom:= e.nom;
      aux.comision:= 0;
      while (e.cod = empAct) do begin
        aux.comision:= aux.comision + e.comision;
        leer(a, e);
      end;
      write(r, aux);
      seek(a, (filePos(a) - 1));
    end;
    close(a);
    close(r);
  end;

  procedure imprimir(var r: archivo);
  var
    e: empleado;
  begin
    reset(r);
    while (not(eof(r))) do begin
      read(r, e);
      writeln(e.cod);
      writeln(e.nom);
      writeln(e.comision:7:2);
      writeln();
    end;
    close(r);
  end;

var
  a, r: archivo;


begin
  assign(a, 'archivoEmpleados');
  assign(r, 'empleados_resumen');
  imprimir(a);
  compactar(a, r);
  imprimir(r);
end.
