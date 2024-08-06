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
           # print(f"Conexión establecida en {puerto}")
            conexion_serial.reset_input_buffer()
            conexion_serial.reset_output_buffer()
            
            array = contenido.split('\n')
            #print("array: ", array)
            for i in range(len(array)):
                hexa = array[i].split(' ')
               # print("hexaCompleto: ", hexa)
                for j in range(len(hexa)):
                    # print("se envió el hexa: ", hexa[j])
                    datos_hex_bytes = bytes.fromhex(hexa[j])
                    # clear buffer
                    
                    conexion_serial.reset_input_buffer()
                    conexion_serial.reset_output_buffer()
                    conexion_serial.write(datos_hex_bytes)
                    time.sleep(0.01)
                    if (array[i] == "00 00 00 FE" and j == 3):
                        print("El receptor esta esperando que la placa termine de enviar datos...")
                        # time.sleep(5)
                        
                        # datos_recibidos = conexion_serial.read_all()
                        while True:
                            datos_recibidos = conexion_serial.read(440)
                            conexion_serial.flushInput()
                            if datos_recibidos:
                                datos_recibidos_hex = datos_recibidos.hex(sep="-", bytes_per_sep=4)  # Convertir a hexadecimal
                                datos_recibidos = datos_recibidos_hex.split("-")
                                for i in range(len(datos_recibidos)):
                                    if(i == 46) : 
                                        # print(f"Program counter : {datos_recibidos[i]}")
                                        # convierte el hexa recibido en string a hexa y le suma 1
                                        pc = int(datos_recibidos[i], 16) + 1
                                        if(pc == 2048) : 
                                            pc = 0
                                        print(f"Program counter : {pc}")
                                        break
                                    if(i < 32) : 
                                        print(f"Registro {i}: {datos_recibidos[i]}")
                                    elif (datos_recibidos[i] != "00000000") : 
                                        print(f"Data memory {i - 31}: {datos_recibidos[i]}")
                            conexion_serial.reset_input_buffer()
                            conexion_serial.reset_output_buffer()
                            time.sleep(2)

                                
                                

    except serial.SerialException as e:
        print(f"Error al abrir puerto serial: {e}")


# Ejemplo de uso
archivo_a_enviar = "fibonachi.txt"  # Reemplaza con el nombre de tu archivo
puerto_serial = "/dev/ttyUSB1"  # Reemplaza con el puerto serie que deseas utilizar

enviar_hexadecimal_a_uart(archivo_a_enviar, puerto_serial)