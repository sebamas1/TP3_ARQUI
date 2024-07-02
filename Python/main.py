import os

INITAL_INSTRUCTION = 'FF 00 00 00 00'
END_INSTRUCTION = '00 00 00 FF'

def load_registers_from_file(file_path):
    registers = {}
    with open(file_path, 'r') as file:
        for line in file:
            if line.strip():  # Ensure line is not empty
                parts = line.strip().split(':')
                registers[parts[0].strip()] = parts[1].strip()
    return registers

def load_opcodes_from_file(file_path):
    opcodes = {}
    with open(file_path, 'r') as file:
        for line in file:
            if line.strip():  # Ensure line is not empty
                parts = line.strip().split(':')
                opcodes[parts[0].strip()] = parts[1].strip()
    return opcodes

def assembly_to_bin(assembly_code, registers, opcodes):
    assembly_code = assembly_code.replace(',', '').replace(';', '')
    # Split assembly code into parts
    parts = assembly_code.split()
    instruction = parts[0].lower()

    if instruction in opcodes:
        opcode = opcodes[instruction]

        if instruction in ['j', 'jal']:
            address = int(parts[1])  # Assuming address is given directly
            # Convert address to binary and format to 26 bits
            address_bin = bin(address)[2:].zfill(26)
            return opcode + address_bin
        
        elif instruction in ['beq', 'bne']:
            rs = registers[parts[1]]
            rt = registers[parts[2]]
            immediate = int(parts[3])  # Assuming immediate value
            # Convert immediate to binary and format to 16 bits
            immediate_bin = bin(immediate)[2:].zfill(16)
            return opcode + rs + rt + immediate_bin
        
        elif instruction == 'lui':
            rt = registers[parts[1]]
            immediate = int(parts[2])  # Assuming immediate value
            # Convert immediate to binary and format to 16 bits
            immediate_bin = bin(immediate)[2:].zfill(16)
            return opcode + '00000' + rt + immediate_bin
        
        elif instruction in ['sll', 'srl', 'sra']:
            rd = registers[parts[1]]
            rt = registers[parts[2]]
            shamt = int(parts[3])  # Assuming shamt value
            # Convert shamt to binary and format to 5 bits
            shamt_bin = bin(shamt)[2:].zfill(5)
            return '000000' + '00000' + rt + rd + shamt_bin + opcode
        
        elif instruction in ['sllv', 'srlv', 'srav']:
            rd = registers[parts[1]]
            rt = registers[parts[2]]
            rs = registers[parts[3]]
            return '000000' + rs + rt + rd + '00000' + opcode
        
        elif instruction in ['addu', 'subu', 'and', 'or', 'xor', 'nor', 'slt']:
            rd = registers[parts[1]]
            rs = registers[parts[2]]
            rt = registers[parts[3]]
            return '000000' + rs + rt + rd + '00000' + opcode
        
        elif instruction in ['jr', 'jalr']:
            rs = registers[parts[1]]
            if instruction == 'jr':
                return '000000' + rs + '000000000000000001000'
            else:
                rd = registers[parts[1]]
                return '000000' + rs + '00000' + rd + '0000000000001001'
        
        else:  # I-type instructions
            rt = registers[parts[1]]
            rs = registers[parts[2]]
            immediate = int(parts[3])  # Assuming immediate value
            # Convert immediate to binary and format to 16 bits
            immediate_bin = bin(immediate)[2:].zfill(16)
            return opcode + rs + rt + immediate_bin
    
    elif assembly_code.lower() == 'hlt':
        return '00000000000000000000000000000001'
    
    else:
        return "Unknown instruction"

def convert_assembly_to_hex_file(file_name):
    ROOT_PATH = os.path.dirname(__file__)
    REGISTERS_FILE = os.path.join(ROOT_PATH, 'utils', 'registers.txt')
    OPCODES_FILE = os.path.join(ROOT_PATH, 'utils', 'opcodes.txt')
    DESTINATION_PATH = os.path.join(ROOT_PATH, 'bin', f'{file_name}.txt')
    
    # Load registers and opcodes from files
    registers = load_registers_from_file(REGISTERS_FILE)
    opcodes = load_opcodes_from_file(OPCODES_FILE)
    
    input_file = os.path.join(ROOT_PATH, 'program_files', f'{file_name}.txt')
    output_file = DESTINATION_PATH
    
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        outfile.write(INITAL_INSTRUCTION + '\n')
        for line in infile:
            assembly_code = line.strip()
            if assembly_code:
                bin_code = assembly_to_bin(assembly_code, registers, opcodes)
                hex_code = hex(int(bin_code, 2))[2:].zfill(8).upper()
                formatted_hex_code = ' '.join(hex_code[i:i+2] for i in range(0, len(hex_code), 2))
                outfile.write(formatted_hex_code + '\n')
        outfile.write(END_INSTRUCTION + '\n')
    return DESTINATION_PATH

def write_program():
    file_name = input('Enter the name of the program file (without extension): ')
    destination_path = convert_assembly_to_hex_file(file_name)

    print(f'The binary instructions have been written to {destination_path}')

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')


def print_mips_banner():
    print(r"""
 .----------------.  .----------------.  .----------------.  .----------------. 
| .--------------. || .--------------. || .--------------. || .--------------. |
| | ____    ____ | || |     _____    | || |   ______     | || |    _______   | |
| ||_   \  /   _|| || |    |_   _|   | || |  |_   __ \   | || |   /  ___  |  | |
| |  |   \/   |  | || |      | |     | || |    | |__) |  | || |  |  (__ \_|  | |
| |  | |\  /| |  | || |      | |     | || |    |  ___/   | || |   '.___`-.   | |
| | _| |_\/_| |_ | || |     _| |_    | || |   _| |_      | || |  |`\____) |  | |
| ||_____||_____|| || |    |_____|   | || |  |_____|     | || |  |_______.'  | |
| |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------' 
    """)
    print("\n" + "*" * 80)

def print_header():
    clear_screen()
    print_mips_banner()
    print("*" * 80)
    print("*" + " " * 78 + "*")
    print("*" + " " * 22 + "TP3 - Arquitectura de Computadoras" + " " * 22 + "*")
    print("*" + " " * 15 + "Facultad de Ciencias Exactas, Físicas y Naturales" + " " * 14 + "*")
    print("*" + " " * 78 + "*")
    print("*" * 80)
    print("*" * 80)
    print()

def print_menu():
    print("Menu:")
    print("*" * 80)
    print("1. Write Program")
    print("2. Other Options")
    print("3. Exit")
    print("*" * 80)

def write_program():
    file_name = input('\nEnter the name of the program file (without extension): ')
    destination_path = convert_assembly_to_hex_file(file_name)
    
    print(f'\nThe binary instructions have been written to {destination_path}')

def other_options():
    print("\nOther Options:")
    print("*" * 50)
    print("1. Display program information")
    print("2. Run simulator")
    print("3. Generate performance report")
    print("*" * 50)


def main_menu():
    print_header()
    
    while True:
        print_menu()
        choice = input("\nSelect an option: ")

        if choice == '1':
            write_program()
            input("\nProgram written successfully. Press Enter to continue...")
            submenu_choice = None
            while submenu_choice != '5':
                print_header()
                print_menu()
                print("\nProgram Options:")
                print("*" * 50)
                print("1. Read Program Counter")
                print("2. Read Memory Address")
                print("3. Read Registers With Values")
                print("4. Display program translation")
                print("5. Exit to Main Menu")
                print("*" * 50)
                submenu_choice = input("\nSelect an option: ")

                if submenu_choice == '1':
                    print("Option to be added later.")
                elif submenu_choice == '2':
                    print("Option to be added later.")
                elif submenu_choice == '3':
                    print("Option to be added later.")
                elif submenu_choice == '4':
                    print("Option to be added later.")
                elif submenu_choice == '5':
                    print("Returning to Main Menu...")
                    break
                else:
                    print("Invalid choice. Please enter a valid option (1-5).")
        elif choice == '2':
            other_options()
            input("\nOptions displayed. Press Enter to continue...")
        elif choice == '3':
            print("\nExiting program.")
            break
        else:
            print("\nInvalid choice. Please enter a valid option (1-3).")

if __name__ == '__main__':
    main_menu()

# def main():
#     while True:
#         print("\nMenu:")
#         print("1. Write Program")
#         print("2. Other Options")
#         print("3. Exit")
#         choice = input("Select an option: ")

#         if choice == '1':
#             write_program()
#             print("\nProgram written successfully.")
#             print("1. Read Program Counter")
#             print("2. Read Memory Address")
#             print("3. Read Registers With Values")
#             print("4. Display program translation")
#             print("5. Exit")
#             choice = input("Select an option: ")

#             if choice == '1':
#                 print("Option to be added later.")
#             elif choice == '2':
#                 print("Option to be added later.")
#             elif choice == '3':
#                 print("Option to be added later.")
#             elif choice == '4':
#                 print("Option to be added later.")
#             elif choice == '5':
#                 print("Exiting program.")
#                 break
#             else:
#                 print("Invalid choice. Please enter a valid option (1-5).")
#         elif choice == '2':
#             print("Other options to be added later.")
#         elif choice == '3':
#             print("Exiting program.")
#             break
#         else:
#             print("Invalid choice. Please enter a valid option (1-3).")

# if __name__ == '__main__':
#     main()