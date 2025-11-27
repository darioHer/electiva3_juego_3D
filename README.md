Barra de Vida y HUD

Se implementó una representación visual del estado de salud del jugador mediante un HUD siempre visible.

Características

Indicador de salud en pantalla (barra o corazones).

Se actualiza automáticamente al recibir daño.

Sincronización con la lógica del jugador (Player.gd).

Compatible con la cámara ortográfica del proyecto.

Funcionamiento

El jugador inicia con un número de vidas.

Cuando recibe daño, el HUD disminuye.

Al llegar a cero, la partida se detiene y se muestra el menú de reinicio.

Menú de Pausa

Se agregó un menú de pausa que permite detener y controlar el flujo del juego.

Características

Activación con la tecla ESC.

El juego se detiene mediante get_tree().paused = true.

Interfaz emergente con opciones:

Reanudar la partida.

Reiniciar la partida completa.

Funcionamiento

El menú permanece activo incluso cuando el juego está detenido.

Al reanudar, continúa el gameplay normal.

Incluye integración con señales de los botones del menú.

Creep Modificado (Enemigos Especiales)

Se añadieron nuevos tipos de enemigos (creeps) para aumentar la variedad y dificultad.

Tipos de Creeps
1. Normal

Velocidad estándar.

Otorga 1 punto al ser eliminado.

2. Rojo Rápido (fast_red)

Se mueve entre 150% y 200% más rápido que el normal.

Color rojo.

Otorga 5 puntos.

3. Morado de Recompensa (bonus_purple)

Aparece solo una vez por oleada.

Color morado.

Otorga 3 puntos.

Funcionamiento

El tipo de creep se asigna en Main.gd según la oleada y probabilidad.

Cada creep ajusta automáticamente:

Velocidad,

Color del material,

Valor del puntaje.
