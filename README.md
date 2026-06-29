# Prueba Técnica – Gestión de Alumnos

## Descripción

Este proyecto implementa una solución para la gestión de alumnos, programas académicos e historial de cambios de estatus utilizando **MariaDB** y **Python** para el análisis de datos. La aplicación permite registrar alumnos, administrar sus inscripciones, consultar su historial de estatus y generar indicadores y visualizaciones a partir de la información almacenada.

---

# Tecnologías utilizadas

* MariaDB
* SQL
* Python 3.12+
* pandas
* SQLAlchemy
* PyMySQL
* matplotlib

---

# Requisitos

* Python 3.12 o superior
* MariaDB 10.x o superior
* pip

---

# Instalación

## 1. Crear un entorno virtual

Linux

```bash
python3 -m venv .venv
```

Activar el entorno

```bash
source .venv/bin/activate
```

---

## 2. Instalar dependencias

```bash
pip install -r requirements.txt
```

---

## 3. Configurar variables de entorno

Crear un archivo `.env` con la configuración de la base de datos.

Ejemplo:

```env
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=prueba_tecnica
DB_USERNAME=root
DB_PASSWORD=tu_password
```

---

# Base de datos

## Crear el esquema

Ejecutar los scripts SQL en el siguiente orden:

1. schema.sql
2. inserts.sql
3. procedures.sql

Estos scripts crearán:

* alumnos
* programas
* inscripciones
* historial_estatus

además de poblar la información inicial y crear el Stored Procedure solicitado.

---

# Ejecutar el proyecto

Una vez configurada la base de datos y las variables de entorno:

```bash
python main.py
```

El programa:

* establece conexión con MariaDB
* carga las tablas en DataFrames de pandas
* realiza los análisis solicitados
* genera las gráficas en la carpeta `graficas/`

---

# Análisis implementados

Se desarrollaron los siguientes análisis utilizando pandas:

* Distribución de estatus por programa
* Evolución mensual de altas y bajas
* Tasa de alumnos activos por programa
* Motivos de baja más frecuentes

---

# Visualizaciones

Se generan las siguientes gráficas mediante matplotlib:

* Barras apiladas de estatus por programa
* Línea de evolución mensual de altas y bajas

Las imágenes se almacenan automáticamente dentro de la carpeta:

```
graficas/
```

---

# Stored Procedure

Se implementó el procedimiento:

```
sp_registrar_cambio_estatus
```

Funciones:

* valida que la inscripción exista
* valida que el nuevo estatus sea diferente al actual
* actualiza la inscripción
* registra el movimiento en el historial
* ejecuta la operación dentro de una transacción

---

# Decisiones de diseño

* Se normalizó la información separando alumnos, programas, inscripciones e historial de estatus.
* El historial de estatus conserva todos los cambios realizados sobre una inscripción para mantener trazabilidad.
* Los programas académicos se almacenan en una tabla independiente para evitar duplicidad de información.
* El estado actual del alumno se almacena en la tabla de inscripciones, mientras que el historial conserva únicamente los cambios.
* Se implementó un Stored Procedure para centralizar la lógica de negocio relacionada con los cambios de estatus y mantener la integridad de la información.
* Los análisis se realizaron utilizando pandas sobre DataFrames cargados desde la base de datos, evitando consultas SQL adicionales para los cálculos.
* Las gráficas se generan como archivos PNG para facilitar su revisión en cualquier entorno, incluso cuando no existe una interfaz gráfica disponible.

---

# Supuestos

* Cada alumno puede tener una o más inscripciones, aunque para los datos de prueba se considera una inscripción por alumno.
* El archivo CSV representa únicamente el estado actual de cada alumno y no contiene historial de movimientos.
* Los movimientos del historial fueron generados manualmente para simular un comportamiento real del sistema.
* El catálogo de programas es fijo para efectos de la prueba técnica.
* Se asume que el identificador del alumno es único y corresponde al proporcionado en el archivo CSV.

---

# Consultas implementadas

Se desarrollaron consultas para:

* alumnos con cambios de estatus en los últimos 30 días
* historial completo de un alumno
* alumnos que reingresaron (baja_empresa → activo)
* tasa de bajas
* indicador de retención por programa

---

# Autor

Aldo Guadalupe Armenta Negrete
