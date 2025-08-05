# Simulador de Ruleta de Casino 🎰
## Descripción 
Este es un simulador de ruleta de casino escrito en Bash que implementa dos técnicas populares de apuestas: 

- **Martingala**: Duplicación automática de la apuesta tras una pérdida.
- **Inverse Labouchere**: Gestión de secuencias de apuestas con un tope renovable.

El programa permite simular diferentes estrategias de apuestas y analizar sus resultados, incluyendo estadísticas detalladas como el número total de jugadas, lista de números perdedores y máximas ganancias alcanzadas. 
El proposito es intentar demostrar la utilidad de las tecnicas, visualizar posibles escenarios y observar como la casa siempre gana

---

## ✨ Características

### Martingala:
- Apostar continuamente a **par/impar**.
- Duplicación automática de la apuesta tras una pérdida.
- Estadísticas al final de la simulación:
  - Número total de jugadas.
  - Lista de números perdedores.
  - Máxima cantidad ganada.

### Inverse Labouchere:
- Implementación de secuencia de apuestas modificable.
- Tope de ganancias configurable para renovar la secuencia.
- Ajuste automático del tope cuando se alcanza un mínimo crítico.
- Estadísticas adicionales:
  - Secuencia máxima alcanzada.
  - Evolución de la secuencia durante el juego.
 
---

## 🎲 Uso 
`./SimuladorRuletaCasino.sh -m [dinero] -t [tecnica]`
### Parámetros
- -m: Cantidad de dinero a apostar
- -t: Tecnica a emplear (martingala o inverseLabrouchere)
- -h: Panel de ayuda

---

## 📖 Notas importantes 
- El programa utiliza colores para mejorar la visualización de los resultados.
- La simulación se ejecuta automáticamente hasta que se agota el dinero disponible.
- Se puede terminar la ejecución en cualquier momento con CTRL+C.
     
