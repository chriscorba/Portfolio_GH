# El programa maneja información de vehículos usando POO

# ----------------------------------------------------------
# Programa: Registro de Vehículos
# Descripción:
# Define una clase Vehiculo con los atributos marca,
# tipo, modelo y color. Además, implementa un método
# que muestra la ficha técnica de cada vehículo.
# ----------------------------------------------------------

# Definición de la clase Vehiculo
class Vehiculo:

    # Constructor de la clase
    def __init__(self, marca, tipo, modelo, color):
        # Inicializa los atributos del objeto
        self.marca = marca
        self.tipo = tipo
        self.modelo = modelo
        self.color = color

    # Método que imprime la ficha técnica del vehículo
    def ficha_tecnica(self):
        print("----- FICHA TÉCNICA -----")
        print(f"Marca : {self.marca}")
        print(f"Tipo  : {self.tipo}")
        print(f"Modelo: {self.modelo}")
        print(f"Color : {self.color}")
        print()

# ------------------------
# Programa principal
# ------------------------

# Creación del primer objeto con datos fijos
vehiculo1 = Vehiculo(
    "Toyota",
    "Sedán",
    "Corolla 2024",
    "Blanco"
)

# Solicitud de datos al usuario para crear el segundo objeto
print("Ingrese los datos del segundo vehículo")

marca = input("Marca: ")
tipo = input("Tipo: ")
modelo = input("Modelo: ")
color = input("Color: ")

vehiculo2 = Vehiculo(marca, tipo, modelo, color)

# Mostrar la ficha técnica de ambos vehículos
print("\n=== VEHÍCULO 1 ===")
vehiculo1.ficha_tecnica()

print("=== VEHÍCULO 2 ===")
vehiculo2.ficha_tecnica()