
import matplotlib.pyplot as plt
import pandas as pd
def grafica_estatus_programa(df_inscripciones, df_programas):

    df = df_inscripciones.merge(
        df_programas,
        on="id_programa"
    )

    tabla = pd.pivot_table(
        df,
        index="nombre_programa",
        columns="estatus",
        values="id_inscripcion",
        aggfunc="count",
        fill_value=0
    )

    ax = tabla.plot(
        kind="bar",
        stacked=True,
        figsize=(12,6)
    )

    ax.set_title("Distribución de estatus por programa")
    ax.set_xlabel("Programa")
    ax.set_ylabel("Número de alumnos")

    plt.xticks(rotation=30, ha="right")
    plt.tight_layout()
    
    plt.tight_layout()
    plt.savefig("graficas/estatus_por_programa.png", dpi=300)
    plt.close()

def grafica_altas_bajas(df_historial):

    df_historial["fecha_cambio"] = pd.to_datetime(
        df_historial["fecha_cambio"]
    )

    df_historial["mes"] = (
        df_historial["fecha_cambio"]
        .dt.to_period("M")
        .astype(str)
    )

    altas = (
        df_historial[
            df_historial["estatus_anterior"].isna()
        ]
        .groupby("mes")
        .size()
    )

    bajas = (
        df_historial[
            df_historial["estatus_nuevo"].isin(
                ["baja_empresa","baja_programa"]
            )
        ]
        .groupby("mes")
        .size()
    )

    evolucion = pd.concat(
        [altas, bajas],
        axis=1
    )

    evolucion.columns = [
        "Altas",
        "Bajas"
    ]

    evolucion = evolucion.fillna(0)

    evolucion.plot(
        kind="line",
        marker="o",
        figsize=(10,5)
    )

    plt.title("Altas y bajas por mes")
    plt.xlabel("Mes")
    plt.ylabel("Cantidad")

    plt.grid(True)

    plt.tight_layout()

    plt.savefig("graficas/grafica_altas_bajas.png", dpi=300)
    plt.close()
