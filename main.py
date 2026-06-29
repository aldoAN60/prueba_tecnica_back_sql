import pandas as pd
from database import get_engine
from analysis import *
import matplotlib.pyplot as plt
from graphics import grafica_estatus_programa
from graphics import grafica_altas_bajas
engine = get_engine()

df_alumnos = pd.read_sql("select * from alumnos", engine)
df_programas = pd.read_sql("select * from programas", engine)
df_inscripciones = pd.read_sql("select * from inscripciones", engine)
df_historial = pd.read_sql("select * from historial_estatus", engine)

df = df_inscripciones.merge(df_programas, on="id_programa")

# distribucion de estatus actual por programa
estatus_programa = pd.pivot_table(
    df,
    index="nombre_programa",
    columns="estatus",
    values="id_inscripcion",
    aggfunc="count",
    fill_value=0
)

#print(estatus_programa)

# evalucion mensual de bajas vs activos
df_historial["fecha_cambio"] = pd.to_datetime(df_historial["fecha_cambio"])

df_historial["mes"] = (df_historial["fecha_cambio"].dt.to_period("M").astype(str))

evolucion = (df_historial.groupby(["mes", "estatus_nuevo"]).size().unstack(fill_value=0))

# print(evolucion)

# Tasa de activos por progrma
resumen = (df
           .groupby("nombre_programa")
           .agg(
               total=("id_inscripcion","count"),
               activos=("estatus", lambda x: (x == "activo").sum())
           )
)

resumen["tasa_activos"] = (resumen["activos"] / resumen["total"] * 100).round(2)

#print(resumen)

# motivo de baja mas frecuente

bajas = df_historial[
    df_historial["estatus_nuevo"].isin(
        ["baja_empresa","baja_programa"]
    )
]

motivos = bajas["motivo"].value_counts()
#print(motivos)
# print(motivos.idxmax())
# print(motivos.max())

# grafica_estatus_programa(df_inscripciones, df_programas)
grafica_altas_bajas(df_historial)


