#Programa que muestra un graficos usando tkinter
# Importamos la libreria tkinter
# tkinter es una libreria de python que nos permite crear interfaces graficas
import tkinter as tk
# Crear la ventana principal
ventana = tk.Tk()
# Asignar un título a la ventana
# El texto aparece en la parte superior de la ventana
ventana.title("Mi primera ventana en Tkinter")
# Definir el tamaño de la ventana
# El tamaño es en pixeles en ancho x alto
ventana.geometry("400x200")
# Crear una etiqueta de texto dentro de la ventana
# text = Mensaje que aparecera
# font = tipo y tamano de letra
etiqueta = tk.Label(
    ventana,
    text="Hola, esta es mi primera interfaz gráfica",
    font=("Arial", 16)
)
# Colocamos la etiqueta dentro de la ventana
# pack() es un metodo que nos permite colocar elementos dentro de la ventana
etiqueta.pack(pady=20)
# mainloop() es un metodo que nos permite mantener la ventana abierta
# el programa estara en ejecución hasta que se cierre la ventana
ventana.mainloop()