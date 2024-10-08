#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
  echo "Seleccione una opción:"
  echo "1. Listar el contenido de un fichero (carpeta)"
  echo "2. Crear un archivo de texto con una línea"
  echo "3. Comparar dos archivos de texto"
  echo "4. Mostrar uso del comando 'awk'"
  echo "5. Mostrar uso del comando 'grep'"
  echo "6. Salir"
}

# Función para listar el contenido de un directorio
listar_contenido() {
  echo "Introduce la ruta absoluta del fichero (carpeta):"
  read ruta
  if [ -d "$ruta" ]; then
    echo "Contenido de $ruta:"
    ls "$ruta"
  else
    echo "El directorio no existe."
  fi
}

# Función para crear un archivo de texto
crear_archivo() {
  echo "Introduce la cadena de texto que deseas almacenar:"
  read cadena
  echo "$cadena" > archivo.txt
  echo "Archivo creado con éxito: archivo.txt"
}

# Función para comparar dos archivos de texto
comparar_archivos() {
  echo "Introduce la ruta del primer archivo:"
  read archivo1
  echo "Introduce la ruta del segundo archivo:"
  read archivo2
  if [ -f "$archivo1" ] && [ -f "$archivo2" ]; then
    diff "$archivo1" "$archivo2"
  else
    echo "Uno o ambos archivos no existen."
  fi
}

# Función para mostrar el uso del comando awk
mostrar_uso_awk() {
  echo "El comando 'awk' puede usarse para procesar texto. Ejemplo:"
  echo "awk '{print \$1}' archivo.txt"
  echo "Resultado del uso de 'awk' en archivo.txt:"
  awk '{print $1}' archivo.txt
}

# Función para mostrar el uso del comando grep
mostrar_uso_grep() {
  echo "El comando 'grep' puede usarse para buscar patrones en un archivo. Ejemplo:"
  echo "grep 'cadena' archivo.txt"
  echo "Introduce la cadena que deseas buscar en archivo.txt:"
  read patron
  grep "$patron" archivo.txt
}

# Bucle principal para mostrar el menú y ejecutar las opciones
opcion=0
while [ "$opcion" -ne 6 ]; do
  mostrar_menu
  read opcion
  case $opcion in
    1) listar_contenido ;;
    2) crear_archivo ;;
    3) comparar_archivos ;;
    4) mostrar_uso_awk ;;
    5) mostrar_uso_grep ;;
    6) echo "Saliendo..." ;;
    *) echo "Opción no válida." ;;
  esac
done
