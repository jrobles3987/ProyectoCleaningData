# CodeBook

## Descripción

Dataset generado a partir del Human Activity Recognition Dataset.

## Transformaciones

1. Se unieron los datasets de entrenamiento y prueba.
2. Se extrajeron solo variables con mean() y std().
3. Se reemplazaron códigos de actividad por nombres descriptivos.
4. Se limpiaron los nombres de variables.
5. Se generó un dataset final con el promedio de cada variable por sujeto y actividad.

## Variables

subject
Identificador del sujeto.

activity
Actividad realizada.

Las demás variables representan mediciones del acelerómetro y giroscopio.