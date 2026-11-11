# EnglishApp - Aprendizaje Activo de Inglés 🎧🇺🇸

Aplicación web de aprendizaje de inglés con **2.010 frases originales** y **4.000 fichas adicionales del manual A2–B1**. Las cinco secciones comparten búsqueda, favoritos, tarjetas y pronunciación.

---

## 🌟 Características Principales

* **2.010 Frases en 80 Categorías:** Desde expresiones cotidianas y saludos hasta vocabulario técnico avanzado (comunicación en equipos de ingeniería, desarrollo FullStack, arquitectura de software, IA y DevOps).
* **Construcción de frases:** 300 fichas repartidas entre afirmativas, negativas e interrogativas.
* **Tiempos verbales:** 600 ejemplos de seis tiempos verbales, con filtro por tiempo.
* **Vocabulario:** 2.000 palabras. Las 1.326 entradas sin traducción en el manual se muestran como «Traducción pendiente».
* **Preguntas y respuestas:** 1.100 preguntas de 11 tipos, con traducción y respuesta modelo bilingüe.
* **Modo Manos Libres (Autoplay):** Reproducción continua en secuencia: frase en inglés $\rightarrow$ pausa configurable $\rightarrow$ traducción en español $\rightarrow$ siguiente frase. Ideal para aprender mientras caminas, viajas o haces deporte.
* **Modo Flashcard (Quiz):** Oculta la traducción en español hasta que decidas revelarla para poner a prueba tu memoria.
* **Voces Sintéticas Nativas:** Integración con la Web Speech API del navegador para pronunciación clara en tiempo real con selector de acento (US/UK) y control de velocidad (0.5x - 1.5x).
* **Favoritos Persistentes:** Marca fichas con estrella ($\star$) para repasarlas por sección. Se guardan en el navegador del dispositivo.
* **100% Responsivo:** Interfaz moderna y adaptable a ordenadores, tablets y teléfonos móviles (diseñada con Tailwind CSS).
* **Biblioteca de Audio MP3 (Offline):** Incluye 80 pistas de audio MP3 (una por categoría, ~51 MB en total) listas para reproducir con la pantalla bloqueada en apps como VLC.

---

## 📁 Estructura del Proyecto

```text
EnglishApp/
├── index.html                 # Interfaz, reproductor y frases originales
├── data.js                    # Base de datos de frases en JavaScript
├── phrases.json               # Frases estructuradas en formato JSON UTF-8
├── manual-data.js             # Fichas A2–B1 listas para el navegador
├── import_manual.py           # Importador del manual de Excel
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

Para actualizar el contenido del manual, guarda el Excel en
`doc/Manual_ingles_A2_B1_4000_elementos.xlsx` y ejecuta `python import_manual.py`.
El navegador carga `manual-data.js` directamente y no necesita el Excel.

---

## 👤 Autor

**Carlos Juárez**  
© 2026 Carlos Juárez · Desplegado en Render con GitHub
