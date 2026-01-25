---
marp: true
theme: gaia
class: invert
paginate: true
header: ' Guía Markdown & Presentaciones HTML '
style: |
  h1 {
    color: #965eea;
  }

footer: 'Miriam Mendieta (2026)'
---

# MARKDOWN

## Creando Presentaciones con Marp

![bg blur:2px dim:0.3](markdow.jpg)

**Miriam Mendieta**
*2-DAMS*

---

## 🧐 ¿Qué es Markdown?

Markdown es un lenguaje de **marcado ligero** que permite dar formato a un texto usando símbolos sencillos.

- **Fácil de aprender**: Sintaxis humana.
- **Versátil**: Documentación, blogs y presentaciones.
- **Estándar**: Usado en GitHub y entornos ágiles.

> **Regla de Oro:** Siempre deja una línea vacía antes y después de cada encabezado (`#`) para que el código sea legible.

---

### 🛠️ Formato Básico de Texto

Para aplicar estilos, usamos estos comandos:

| Comando | Ejemplo | Salida |
| :--- | :--- | :--- |
| `# Encabezado` | `# Título H1` | **Título H1** |
| `##` a `######` | `### Subtítulo H3` | **Subtítulo H3** |
| `**Negrita**` | `**Texto Importante**` | **Texto Importante** |
| `*Cursiva*` | `*Énfasis*` | *Énfasis* |
| `~~Tachado~~` | `~~Obsoleto~~` | ~~Obsoleto~~ |
| `` `Código` `` | `` `print("Hello")` | `print("Hello")` |

---

## 📜 Listas y Tareas (Checklists)

Las listas ayudan a organizar ideas. La sangría (espacios) es clave.

### Ejemplo de código para listas

```markdown
- Elemento principal
  - Sub-elemento (deja 2 espacios)
- [x] Tarea lista
- [ ] Tarea pendiente
```

---

### Listas Ordenadas

1. Primer ítem
2. Segundo ítem
   1. Sub-ítem #el segundo nivel se genera dejando la tabulación
3. Tercer ítem

---

### Listas Desordenadas

- Un elemento
  - Un sub-elemento
- Otro elemento
- Un tercer elemento

### Listas de Tareas (Checklists)

- [x] Tarea Completada
- [ ] Tarea Pendiente
- [ ] Otra Tarea

---

## 🔗 Enlaces y Referencias

Puedes enlazar a recursos externos o internos de forma sencilla.

### Ejemplo de uso

- [Visitar Google](https://www.google.com)
- [Contáctame por Email](mailto:tu.email@example.com)

### Código fuente

```markdown
[Texto visible](https://url.com)
[Email](mailto:email@ejemplo.com)
```

---

### Imagen Estándar

![Logo de Marp](https://marp.app/assets/marp.svg)

 ```markdown
![Logo de Marp](https://marp.app/assets/marp.svg)
```

---

### Imagen con Tamaño Específico

![width:150px](https://marp.app/assets/marp.svg)

```markdown
![width:150px](https://marp.app/assets/marp.svg)
```

### Imagen de Fondo (con opacidad)

![bg opacity:.2](https://picsum.photos/id/237/800/600)
**Texto sobre la imagen de fondo**

```markdown
![bg opacity:.2](https://picsum.photos/id/237/800/600)
```

---

## Bloques de Código Avanzados

Esencial para mostrar ejemplos de programación.

```python
# python
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n-1)

print(factorial(5))
```

```javascript
// javascript
const sum = (a, b) => a + b;
console.log(sum(10, 20));
```

> Marp soporta resaltado de sintaxis para casi todos los lenguajes.

---

## Tablas de Datos

 Las tablas permiten organizar datos complejos. Se construyen con tres partes esenciales:

1. **Encabezado**: La primera fila define los títulos.
2. **Línea de alineación**: Define si el texto va a la izquierda, centro o derecha.
3. **Cuerpo**: Los datos separados por barras `|`.

---

| Característica | Opción A | Opción B |
| :--- | :--- | :--- |
| **Rendimiento** | ⭐️⭐️⭐️ | ⭐️⭐️⭐️⭐️ |
| **Costo** | Bajo | Alto |
| **Facilidad** | Media | Alta |

### Ejemplo de código fuente

```markdown
| Característica | Opción A | Opción B |
| :---           | :----:   | ---:     | #derecha - medio -izquierda
| **Rendimiento**| Alta     | Media    |
```

---

## Citas y Bloques

Las citas resaltan frases importantes, mientras que las notas (bloques de alerta) sirven para aclaraciones.

### Ejemplo Visual

> "La calidad nunca es un accidente; siempre es el resultado de un esfuerzo inteligente."
> -- **John Ruskin**
---

### Formato a utilizar

```markdown
> "Aquí va el texto de la cita."
> -- **Autor**

```

1. **Citas (`>`):** Se crean colocando el signo "mayor que" al inicio de cada línea. Para que ele  autor aparezca abajo, usa dos guiones `--`.
2. **Anidamiento:**  doble signo `>>`,  una cita dentro de otra cita.
3. **Bloque de código:**  se utilizan los tres acentos graves (```) .

---

## ⚙️ Directivas de Marp (Para Presentaciones)

Controla el comportamiento de las diapositivas.

- `marp: true`: Activa la extensión.
- `theme: gaia` / `default` / `uncover`: Cambia el estilo global.
- `class: invert`: Invierte colores (modo oscuro).
- `paginate: true`: Muestra números de página.
- `backgroundColor: #f0f0f0`: Establece un color de fondo.
- `header: 'Mi encabezado'` / `footer: 'Mi pie de página'`: Añade texto fijo.

---

## Temas Disponibles

Marp viene con 3 temas predefinidos, pero puedes crear los tuyos:

- `default`: Estilo limpio y clásico.
- `gaia`: Moderno, con transiciones suaves y buen contraste.
- `uncover`: Ideal para resaltar títulos grandes.

---

## Cómo generar el archivo html

- Abre tu archivo .md en VS Code.

- Busca en la esquina superior derecha del editor un icono de una "M" azul (el logo de Marp), o presiona Ctrl + Shift + P y escribe:    Marp: Export Slide Deck....

- Se abrirá una ventana pequeña en la parte superior. Selecciona la opción que dice "Export Slide Deck...".

- Se abrirá la ventana de tu computadora para guardar archivos: poner nombre y Tipo/Formato: HTML. Guardar

---

## Exportación y Distribución

Convierte tu `.md` en formatos estándar:

1. **HTML**: `Icono M` > `Export Slide Deck` > `HTML`.
    - **Ventaja**: Interactivo, animaciones, funciona en cualquier navegador.
2. **PDF**: `Icono M` > `Export Slide Deck` > `PDF`.
    - **Ventaja**: Estático, fácil de imprimir, estándar para documentos.
3. **PPTX (PowerPoint)**: `Icono M` > `Export Slide Deck` > `PPTX`.
    - **Ventaja**: Editable en PowerPoint.

---
