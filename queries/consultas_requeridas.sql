/*-- Alumnos que tuvieron al menos un cambio de estatus en los últimos 30 días --*/

select distinct
  a.id_alumno,
  a.nombre,
  i.estatus as estatus_actual,
  he.fecha_cambio
from historial_estatus as he 
  join inscripciones as i on i.id_inscripcion = he.id_inscripcion
join alumnos as a on a.id_alumno = i.id_alumno
  where he.fecha_cambio >= date_sub(current_date(), interval 30 day)
  ;

/*-- Tasa de baja por programa (bajas / total inscritos) --*/
SELECT
    total_activos,
    total_bajas,
-- total_bajas * 100 / total_activos AS tasa_bajas
 total_bajas * 100 / (total_activos + total_bajas) AS tasa_bajas
FROM (
    SELECT
        SUM(CASE WHEN estatus = 'activo' THEN 1 ELSE 0 END) AS total_activos,
        SUM(CASE WHEN estatus <> 'activo' THEN 1 ELSE 0 END) AS total_bajas
    FROM inscripciones
) t;
/* -- Historial completo de un alumno específico (JOIN de 4 tablas)-- */

select 
  i.id_inscripcion,
  a.nombre,
  a.empresa,
  p.nombre_programa,
  i.fecha_inscripcion,
  he.estatus_anterior,
  he.estatus_nuevo,
  he.motivo,
  he.fecha_cambio
from historial_estatus as he
join inscripciones as i on i.id_inscripcion = he.id_inscripcion
join programas as p on p.id_programa = i.id_programa
join alumnos as a on a.id_alumno = i.id_alumno
where a.id_alumno = 1004 order by fecha_cambio desc;

/* -- Alumnos que pasaron de baja_empresa a activo (reingreso) -- */
select
    a.id_alumno,
    a.nombre,
    a.empresa,
    p.nombre_programa,
    h.fecha_cambio as fecha_reingreso,
    h.motivo
from historial_estatus as h
join inscripciones as i on  h.id_inscripcion = i.id_inscripcion
join alumnos as a on i.id_alumno = a.id_alumno
join programas as p on  i.id_programa = p.id_programa
WHERE h.estatus_anterior = 'baja_empresa'
  AND h.estatus_nuevo = 'activo'
ORDER BY h.fecha_cambio DESC;

/* indicador propuesto de tasa de permanencia de alumnos*/
SELECT
    COUNT(*) AS total_inscripciones,

    SUM(CASE
            WHEN estatus = 'activo'
            THEN 1
            ELSE 0
        END) AS alumnos_activos,

    ROUND(
        (
            SUM(CASE
                    WHEN estatus = 'activo'
                    THEN 1
                    ELSE 0
                END) * 100.0
        ) / COUNT(*),
        2
    ) AS tasa_permanencia
FROM inscripciones;