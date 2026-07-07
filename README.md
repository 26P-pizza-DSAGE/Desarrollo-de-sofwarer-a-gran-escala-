# 🍕 Pizza Builder — Seguimiento de pedido

Primera versión de una pantalla de **seguimiento de pedido en tiempo real** para la pizzería "Pizza Builder". Muestra:

- Estado del pedido ("Tu pizza va en camino") con contador de tiempo estimado.
- Datos del repartidor (nombre, foto/avatar, calificación, botones de llamar/mensaje).
- Un mapa animado donde la moto del repartidor se mueve por una ruta hacia el destino.
- Transición automática a la pantalla **"¡Pizza entregada!"** una vez termina el recorrido.

Es un **archivo único** (`index.html`) sin dependencias de backend: HTML, CSS y JavaScript "vanilla" en un solo lugar, más una conexión a Google Fonts. Pensado como punto de partida para conectar más adelante con datos reales (GPS del repartidor, backend de pedidos, etc.).

## 🔍 Demo

Abre `index.html` en cualquier navegador. No necesita servidor ni instalación.

Para probar el flujo completo sin esperar el conteo real, usa el botón **"Simular entrega ahora (demo)"** que aparece al final de la pantalla.

## 📁 Estructura del proyecto

```
pizza-builder-tracking/
├── index.html      # Toda la interfaz: HTML + CSS + JS
├── README.md        # Este archivo
└── GUIA-CODIGO.md   # Explicación del código, sección por sección
```

## 🚀 Cómo publicarlo (GitHub Pages)

1. Crea el repositorio en GitHub y sube el código (ver sección siguiente).
2. En GitHub, ve a **Settings → Pages**.
3. En "Source", selecciona la rama `main` y la carpeta `/ (root)`.
4. Guarda. En unos minutos tu sitio quedará disponible en:
   `https://tu-usuario.github.io/nombre-del-repo/`

## 🧑‍💻 Cómo subirlo a GitHub desde cero

Con GitHub CLI (`gh`) instalado y sesión iniciada:

```bash
cd pizza-builder-tracking
git init
git add .
git commit -m "Primera version: pantalla de seguimiento de pedido"
gh repo create pizza-builder-tracking --public --source=. --remote=origin --push
```

Sin `gh` (creando el repo manualmente en github.com primero):

```bash
cd pizza-builder-tracking
git init
git add .
git commit -m "Primera version: pantalla de seguimiento de pedido"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/pizza-builder-tracking.git
git push -u origin main
```

> Reemplaza `TU-USUARIO` y `pizza-builder-tracking` por tu usuario y el nombre real del repo.

## 🛠 Personalización rápida

| Qué quieres cambiar | Dónde tocar |
|---|---|
| Nombre y calificación del repartidor | `index.html`, línea ~386-387 |
| Duración del recorrido simulado | variable `totalSeconds` en el `<script>`, línea ~452 |
| Colores de marca | variables `:root` al inicio del `<style>`, líneas 10-21 |
| Texto de los mensajes de estado | `#status-text`, `#eyebrow-text`, línea ~348 y función `markDelivered()` |
| Ruta del mapa | atributo `d`/`path` de `#route` y `<animateMotion>`, líneas ~412 y ~428 |

## 🗺 Próximos pasos sugeridos

- Conectar el mapa a coordenadas reales (Google Maps / Mapbox) en vez de la ruta ilustrada.
- Reemplazar el conteo simulado por el estado real del pedido desde un backend (WebSocket o polling).
- Añadir notificaciones push cuando cambia el estado del pedido.

## 📄 Licencia

Este proyecto es un punto de partida de diseño/demo. Úsalo y modifícalo libremente para tu pizzería.
