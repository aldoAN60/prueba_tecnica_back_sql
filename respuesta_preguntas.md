## Respuestas

## SQL / mariaDB
1. Tu tabla historial_estatus crece rápido. ¿Qué harías para que las consultas de historial no se vuelvan lentas con el tiempo?

Crearia indices sobre las columnas más consultadas, como id_inscripcion y fecha_cambio. Además evitaría consultas que recorran toda la tabla y, si el volumen fuera muy grande, consideraría dividirla o particionarla por fecha para mejorar el rendimiento de las consultas históricas.

2. Un alumno aparece dos veces con estatus activo seguido en el historial, sin una baja intermedia. ¿Cómo detectarías ese problema y cómo lo evitarías desde el diseño?

Lo detectaría consultando el historial ordenado por fecha y comparando cada registro con el anterior para identificar estatus consecutivos iguales y para evitarlo validaria en el stored procedure que el nuevo estatus sea diferente al estatus actual antes de registrar el cambio.

## Python / Pandas

Pregunta 3
Tienes un DataFrame con 50,000 registros de movimientos. Al hacer un groupby por programa y mes, algunos meses no aparecen para ciertos programas. ¿Qué causa eso y cómo lo resuelves?

groupby solo devuelve las combinaciones que existen en los datos si un programa no tuvo movimientos en un mes, esa combinación no aparece. Lo solucionaría creando todas las combinaciones posibles con un MultiIndex o una tabla calendario y rellenando los valores faltantes con cero mediante reindex(fill_value=0)

Pregunta 4
¿Cuál es la diferencia entre usar merge y join en pandas? ¿Cuándo usarías cada uno?

merge permite unir DataFrames utilizando una o varias columnas como llave, de forma similar a un JOIN en SQL y join trabaja principalmente sobre los índices y es más conveniente cuando los DataFrames ya tienen el índice configurado correctamente. En la mayoría de los casos usaría merge por ser más flexible.

## Angular

Pregunta 5
Tu componente de tabla de alumnos re-renderiza completo cada vez que cambias el estatus de uno solo. ¿Qué causaría eso y cómo lo optimizarías?

Esto ocurre porque angular vuelve a ejecutar la deteccion de cambios para toda la lista entonces lo optimizaria usando ChangeDetectionStrategy.OnPush y un trackBy para que angular solo actualice el elemento que realmente cambio.

Pregunta 6
¿Dónde guardarías el estatus actual de los alumnos en una app Angular sin backend: en el componente directamente, en un Service compartido, o en localStorage? Justifica tu elección.

Mantendría el estado en un Service utilizando un BehaviorSubject para compartir la información entre componentes. Además, lo persistiría en localStorage para conservar los datos al recargar la página. Evitaría guardarlo únicamente en un componente porque el estado se perderia y no seria reutilizable.


