import tkinter as tk
from tkinter import messagebox
def agregar_elemento():
    elemento = entrada.get()
    if elemento != "":
        # insert() agrega un elemento al listbox
        listbox.insert(tk.END, elemento)
        # Limpiamos la entrada de texto
        entrada.delete(0, tk.END)
    else:
        messagebox.showwarning(
            "Advertencia",
            "Ingresa un elemento."
            )
def eliminar_elemento():
    seleccion = listbox.curselection()
    if seleccion:
        listbox.delete(seleccion)
    else:
        messagebox.showwarning(
            "Advertencia",
            "Selecciona un elemento para eliminar."
    )

def mostrar_lista():
    elementos = listbox.get(0, tk.END)
    texto = ""
    for elemento in elementos:
        texto += elemento + "\n"
    etiqueta_resultado.config(
        text=texto
    )

ventana = tk.Tk()
ventana.title("Manejo de ListBox")
ventana.geometry("500x500")

titulo = tk.Label(
    ventana,
    text="Manejo de Elementos",
    font=("Arial", 18)
)
titulo.pack(pady=10)

entrada = tk.Entry(
    ventana,
    width=30,
    font=("Arial", 14)
)
entrada.pack(pady=10)

frame_botones = tk.Frame(ventana)
frame_botones.pack(pady=10)

boton_agregar = tk.Button(
    frame_botones,
    text="Agregar",
    command=agregar_elemento,
    width=12,
)
boton_agregar.grid(row=0, column=0, padx=5)

boton_eliminar = tk.Button(
    frame_botones,
    text="Eliminar",
    command=eliminar_elemento,
    width=12,
)
boton_eliminar.grid(row=0, column=1, padx=5)

boton_mostrar = tk.Button(
    frame_botones,
    text="Mostrar Lista",
    command=mostrar_lista,
    width=12,    
)
boton_mostrar.grid(row=0, column=2, padx=5)

listbox = tk.Listbox(
    ventana,
    width=40,
    height=10,
    font=("Arial", 12)
)
listbox.pack(pady=15)

etiqueta_resultado = tk.Label(
    ventana,
    text="",
    font=("Arial", 12),
    justify="left"
)
etiqueta_resultado.pack(pady=10)

ventana.mainloop()










# El programa maneja unas listas de elementos usando Listbox de tkinter
# Desarrolla un programa en python utilizando tkinter  que permita agregar elementops a un listbox, eliminar elementos seleccionados y mostrar lista completa, los elementos deben estar bien distribuidos para que se aprecien totalmente, explica el funcionamiento del codigo mas importante y nuevo de este programa

# Importamos la libreria tkinter
# tkinter es una libreria de python que nos permite crear interfaces graficas