import serial
import time
import os

def enviar_hexadecimal_a_uart(archivo, puerto):
    archivo = os.path.join(os.path.dirname(__file__), archivo)
    with open(archivo, 'r') as file:
        # Leer el contenido del archivo
        contenido = file.read()

    try:
        with serial.Serial(port=puerto, baudrate=9600, timeout=1) as conexion_serial:
            print(f"Conexión establecida en {puerto}")
            
            array = contenido.split('\n')
            print("array: ", array)
            for i in range(len(array)):
                hexa = array[i].split(' ')
                print("hexaCompleto: ", hexa)
                for j in range(len(hexa)):
                    print("se envió el hexa: ", hexa[j])
                    datos_hex_bytes = bytes.fromhex(hexa[j])
                    # clear buffer
                    
                    conexion_serial.flushInput()
                    conexion_serial.write(datos_hex_bytes)
                    time.sleep(0.05)
                    if (array[i] == "00 00 00 FF" and j == 3):
                        print("Comienza a leer la UART")
                        time.sleep(1)
                        # Leer continuamente desde la UART y mostrar lo recibido
                        while True:
                            counter = 0                            
                            datos_recibidos = conexion_serial.read_all()
                            conexion_serial.flushInput()
                            if datos_recibidos:
                                datos_recibidos_hex = datos_recibidos.hex(sep="-", bytes_per_sep=4).upper()  # Convertir a hexadecimal
                                print("Datos recibidos desde UART en hexadecimal:", datos_recibidos_hex)
                                    
                                # time.sleep(1)
                                # datos_hex_bytes_new = bytes.fromhex("FF")
                                # conexion_serial.flushInput()
                                # conexion_serial.write(datos_hex_bytes_new)
                                # print("Se envió un FF")

                                # time.sleep(1)
                                # datos_hex_bytes_new = bytes.fromhex("FF")
                                # conexion_serial.flushInput()
                                # conexion_serial.write(datos_hex_bytes_new)
                                # print("Se envió un FF")
                                
                                # continue_for = True  # Activar la señal para continuar el bucle for
                        #         break  # Salir del bucle while
                        # if continue_for:
                        #     continue_for = False  # Restablecer la señal
                        #     break  # Salir del bucle for


            

    except serial.SerialException as e:
        print(f"Error al abrir puerto serial: {e}")


# Ejemplo de uso
archivo_a_enviar = "archivo.txt"  # Reemplaza con el nombre de tu archivo
puerto_serial = "/dev/ttyUSB1"  # Reemplaza con el puerto serie que deseas utilizar

enviar_hexadecimal_a_uart(archivo_a_enviar, puerto_serial)