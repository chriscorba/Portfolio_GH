#Crearemos una calculadora grafica
import tkinter as tk

def obtener_numeros():
    try:
        num1 = float(entrada_num1.get())
        num2 = float(entrada_num2.get())
        return num1, num2
    except ValueError:
        resultado.config(text="Error: ingrese números válidos.")
        return None, None

def sumar():
    num1, num2 = obtener_numeros()
    if num1 is not None:
        resultado.config(text=f"Resultado: {num1 + num2}")

def restar():
    num1, num2 = obtener_numeros()
    if num1 is not None:
        resultado.config(text=f"Resultado: {num1 - num2}")

def multiplicar():
    num1, num2 = obtener_numeros()
    if num1 is not None:
        resultado.config(text=f"Resultado: {num1 * num2}")

def dividir():
    num1, num2 = obtener_numeros()
    if num1 is not None:
        if num2 == 0:
            resultado.config(text="Error: no se puede dividir entre cero.")
        else:
            resultado.config(text=f"Resultado: {num1 / num2}")


ventana = tk.Tk()
ventana.title("Calculadora básica")
ventana.geometry("350x360")

tk.Label(ventana, text="Calculadora básica", font=("Arial", 16)).pack(pady=10)

tk.Label(ventana, text="Primer número:").pack(pady=5)
entrada_num1 = tk.Entry(ventana)
entrada_num1.pack(pady=5)

tk.Label(ventana, text="Segundo número:").pack(pady=5)
entrada_num2 = tk.Entry(ventana)
entrada_num2.pack(pady=5)

tk.Button(ventana, text="Sumar", width=15, command=sumar).pack(pady=5)
tk.Button(ventana, text="Restar", width=15, command=restar).pack(pady=5)
tk.Button(ventana, text="Multiplicar", width=15, command=multiplicar).pack(pady=5)
tk.Button(ventana, text="Dividir", width=15, command=dividir).pack(pady=5)

resultado = tk.Label(ventana, text="Resultado: ")
resultado.pack(pady=10)

ventana.mainloop()