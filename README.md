# EnglishApp - Aprendizaje Activo de Inglés 🎧🇺🇸

Aplicación web interactiva y biblioteca de audio diseñada para el aprendizaje y práctica de **2.010 frases esenciales en inglés** (con pronunciación en inglés de Estados Unidos y traducción al español), optimizada especialmente para uso en teléfonos móviles con auriculares.

---

## 🌟 Características Principales

* **2.010 Frases en 80 Categorías:** Desde expresiones cotidianas y saludos hasta vocabulario técnico avanzado (comunicación en equipos de ingeniería, desarrollo FullStack, arquitectura de software, IA y DevOps).
* **Modo Manos Libres (Autoplay):** Reproducción continua en secuencia: frase en inglés $\rightarrow$ pausa configurable $\rightarrow$ traducción en español $\rightarrow$ siguiente frase. Ideal para aprender mientras caminas, viajas o haces deporte.
* **Modo Flashcard (Quiz):** Oculta la traducción en español hasta que decidas revelarla para poner a prueba tu memoria.
* **Voces Sintéticas Nativas:** Integración con la Web Speech API del navegador para pronunciación clara en tiempo real con selector de acento (US/UK) y control de velocidad (0.5x - 1.5x).
* **Favoritos Persistentes:** Marca frases con estrella ($\star$) para filtrarlas y repasarlas más tarde (guardadas en `localStorage` de tu dispositivo).
* **100% Responsivo:** Interfaz moderna y adaptable a ordenadores, tablets y teléfonos móviles (diseñada con Tailwind CSS).
* **Biblioteca de Audio MP3 (Offline):** Incluye 80 pistas de audio MP3 (una por categoría, ~51 MB en total) listas para reproducir con la pantalla bloqueada en apps como VLC.

---

## 📁 Estructura del Proyecto

```text
EnglishApp/
├── index.html                 # Aplicación web completa y auto-contenida
├── data.js                    # Base de datos de frases en JavaScript
├── phrases.json               # Frases estructuradas en formato JSON UTF-8
├── generate_all_audios.ps1    # Script PowerShell generador de audios (SAPI5 + ffmpeg)
├── render.yaml                # Configuración para despliegue automático en Render
├── README.md                  # Documentación del proyecto
└── Audios/                    # 80 pistas MP3 ordenadas por categoría (01 a 80)
    ├── 01_1-25_Saludos_y_expresiones_basicas.mp3
    ├── 02_26-50_Vida_diaria.mp3
    └── ...
```

---

## 🚀 Despliegue en Render (Static Site)

1. En [Render Dashboard](https://dashboard.render.com/), selecciona **New +** $\rightarrow$ **Static Site**.
2. Conecta este repositorio (`EnglishApp`).
3. Ajustes de configuración:
   * **Name:** `english-app`
   * **Branch:** `main`
   * **Build Command:** *(dejar en blanco)*
   * **Publish Directory:** `.`
4. Haz clic en **Create Static Site**.

---

## 💻 Uso Local

Puedes abrir directamente el archivo `index.html` en cualquier navegador web moderno (Chrome, Edge, Safari, Firefox), o iniciar un servidor local con Python:

```bash
python -m http.server 8000
```
Y abrir `http://localhost:8000` en tu navegador.

---

## 👤 Autor

**Carlos Juárez**  
© 2026 Carlos Juárez · Desplegado en Render con GitHub
