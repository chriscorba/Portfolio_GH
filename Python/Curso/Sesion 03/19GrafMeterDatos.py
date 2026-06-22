# El programa permite capturar datos con Entry
import tkinter as tk

def mostrar_saludo():
    nombre = entrada_nombre.get()
    if nombre != "":
        etiqueta_resultado.config(text=f"Hola, {nombre}. ¡Bienvenido a Tkinter!")
    else:
        etiqueta_resultado.config(text="Por favor, ingresa tu nombre.", font=("Arial", 14))

ventana = tk.Tk()
ventana.title("Saludo con Tkinter")
ventana.geometry("400x250")

etiqueta_instruccion = tk.Label(ventana,
                                text="Ingrese su nombre:",
                                font=("Arial", 16)
)
etiqueta_instruccion.pack(pady=10)

entrada_nombre = tk.Entry(ventana,
                          width=30,
                          font=("Arial", 14)
)
entrada_nombre.pack(pady=5)

boton_saludar = tk.Button(ventana,
                          text="Saludar",
                          font=("Arial", 14),
                          command=mostrar_saludo
)
boton_saludar.pack(pady=10)

etiqueta_resultado = tk.Label(ventana,
                              text="",
                              font=("Arial", 16)
)
etiqueta_resultado.pack(pady=10)

ventana.mainloop()