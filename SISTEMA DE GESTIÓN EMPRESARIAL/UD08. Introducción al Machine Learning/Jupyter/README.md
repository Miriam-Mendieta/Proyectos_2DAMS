# Análisis de Ventas de la Tienda

Este proyecto se centra en analizar los datos de ventas de una tienda para extraer información valiosa que ayude en la toma de decisiones estratégicas.

## Tabla de Contenidos

- [Introducción](#introducción)
- [Requisitos](#requisitos)
- [Uso](#uso)
- [Análisis Realizado](#análisis-realizado)
- [Visualizaciones](#visualizaciones)
- [Licencia](#licencia)

## Introducción

El objetivo de este proyecto es realizar un análisis  de las ventas mediante el uso de Python, Jupyter Notebook y la biblioteca Pandas. Se extraerán tendencias y patrones que ayudarán a mejorar las estrategias de ventas.

## Requisitos

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- Python 3.x
- Jupyter Notebook
- Pandas
- Matplotlib
- Seaborn


Puedes instalar las bibliotecas necesarias con:

```bash
pip install pandas matplotlib seaborn nbconvert
```

Para este ejercicio, vamos a usar uno de los datasets de Online Retail que contiene transacciones reales de 2010-2011.
[Kaggle - E-Commerce Data](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

## Uso

Este proyecto incluye un análisis  de las ventas por categorías, tendencias mensuales y visualizaciones interactivas que ilustran los resultados.

## Análisis Realizado

- Limpieza de Datos: Se identificaron y manejar los valores nulos.
- Análisis Exploratorio de Datos: Estadísticas descriptivas y medidas de tendencia.
- Comparativas por categoría y mes.

## Visualizaciones

Las visualizaciones incluyen:

- Gráficas de líneas que muestran las tendencias de ventas .
- Gráficas de Análisis de Ventas 2011.

## Generación de Informes

- En la terminal ejecutar:
- Para un PDF --> jupyter nbconvert --to pdf analisis_ventas_ecommerce.ipynb --no-prompt
- Para un HTML --> jupyter nbconvert --to html analisis_ventas_ecommerce.ipynb --no-prompt


## Licencia

Este proyecto está bajo la Licencia MIT. Para más detalles, consulta el archivo LICENSE.

Autora: Miriam Mendieta .- 
