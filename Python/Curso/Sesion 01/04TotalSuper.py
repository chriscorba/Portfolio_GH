# El programa debe pedir el costo de 3 productos y muestre el subtotal, el iva (16%) y el total a pagar

# Pedir el costo de 3 productos
producto1 = float(input("Ingresa el costo del producto 1: "))
producto2 = float(input("Ingresa el costo del producto 2: "))
producto3 = float(input("Ingresa el costo del producto 3: "))
producto4 = float(input("Ingresa el costo del producto 4: "))

# Calcular subtotal
subtotal = producto1 + producto2 + producto3 + producto4

# Calcular IVA (16%)
iva = subtotal * 0.16

# Calcular total
total = subtotal + iva

# Mostrar resultados
print("\n--- Resumen de compra ---")
print(f"Subtotal: ${subtotal:.2f}")
print(f"IVA (16%): ${iva:.2f}")
print(f"Total a pagar: ${total:.2f}")
print("\n¡Gracias por tu compra!")
