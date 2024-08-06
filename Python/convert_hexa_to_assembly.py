import os

def hex_to_bin(hex_code):
    """Convert a hexadecimal string to a 32-bit binary string."""
    hex_code = hex_code.replace(" ", "")  # Remove spaces
    return bin(int(hex_code, 16))[2:].zfill(32)

def bin_to_assembly(bin_code):
    """Convert a 32-bit binary MIPS instruction to assembly."""
    if bin_code == '00000000000000000000000000000001':
        return 'hlt'
    if bin_code == '00000000000000000000000011111111':
        return ''

    opcode = bin_code[0:6]
    rs = bin_code[6:11]
    rt = bin_code[11:16]
    rd = bin_code[16:21]
    shamt = bin_code[21:26]
    funct = bin_code[26:32]
    immediate = bin_code[16:32]

    # Opcodes dictionary for I-type and J-type instructions
    opcodes = {
        '100000': 'lb',
        '100001': 'lh',
        '100011': 'lw',
        '100111': 'lwu',
        '100100': 'lbu',
        '101000': 'sb',
        '101001': 'sh',
        '101011': 'sw',
        '001000': 'addi',
        '001100': 'andi',
        '001101': 'ori',
        '001110': 'xori',
        '001111': 'lui',
        '001010': 'slti',
        '000100': 'beq',
        '000101': 'bne',
        '000010': 'j',
        '000011': 'jal'
    }

    # Registers dictionary
    registers = {
        '00000': '$zero',
        '00001': '$at',
        '00010': '$v0',
        '00011': '$v1',
        '00100': '$a0',
        '00101': '$a1',
        '00110': '$a2',
        '00111': '$a3',
        '01000': '$t0',
        '01001': '$t1',
        '01010': '$t2',
        '01011': '$t3',
        '01100': '$t4',
        '01101': '$t5',
        '01110': '$t6',
        '01111': '$t7',
        '10000': '$s0',
        '10001': '$s1',
        '10010': '$s2',
        '10011': '$s3',
        '10100': '$s4',
        '10101': '$s5',
        '10110': '$s6',
        '10111': '$s7',
        '11000': '$t8',
        '11001': '$t9',
        '11010': '$k0',
        '11011': '$k1',
        '11100': '$gp',
        '11101': '$sp',
        '11110': '$fp',
        '11111': '$ra'
    }

    if opcode == '000000':  # R-type instructions
        rtype_functions = {
            '000000': 'sll',
            '000010': 'srl',
            '000011': 'sra',
            '000100': 'sllv',
            '000110': 'srlv',
            '000111': 'srav',
            '100001': 'addu',
            '100011': 'subu',
            '100100': 'and',
            '100101': 'or',
            '100110': 'xor',
            '100111': 'nor',
            '101010': 'slt',
            '001000': 'jr',
            '001001': 'jalr'
        }

        if funct in rtype_functions:
            instruction = rtype_functions[funct]
            rs_reg = registers[rs]
            rt_reg = registers[rt]
            rd_reg = registers[rd]
            shamt_value = str(int(shamt, 2))

            # Handle special cases for shift instructions and jump register
            if instruction in ['sll', 'srl', 'sra']:
                return f"{instruction} {rd_reg}, {rt_reg}, {shamt_value}"
            elif instruction == 'jr':
                return f"{instruction} {rs_reg}"
            elif instruction == 'jalr':
                return f"{instruction} {rd_reg}, {rs_reg}"
            else:
                return f"{instruction} {rd_reg}, {rs_reg}, {rt_reg}"
        else:
            return "Unknown R-type instruction"
    
    elif opcode in opcodes:  # I-type and J-type instructions
        instruction = opcodes[opcode]
        rs_reg = registers[rs]
        rt_reg = registers[rt]
        immediate_value = str(int(immediate, 2))
        
        if instruction in ['j', 'jal']:
            address = str(int(bin_code[6:], 2))
            return f"{instruction} {address}"
        elif instruction in ['beq', 'bne']:
            return f"{instruction} {rs_reg}, {rt_reg}, {immediate_value}"
        elif instruction == 'lui':
            return f"{instruction} {rt_reg}, {immediate_value}"
        else:
            return f"{instruction} {rt_reg}, {rs_reg}, {immediate_value}"
    
    else:
        return "Unknown instruction"

def convert_hex_file_to_assembly(file_name):
    ROOT_PATH = os.path.dirname(__file__)
    LOCATION_PATH = ROOT_PATH + '/program_files/' + file_name + '.txt'
    DESTINATION_PATH = ROOT_PATH + '/bin/' + file_name + '.txt'
    
    input_file = LOCATION_PATH
    output_file = DESTINATION_PATH
    
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            hex_code = line.strip()
            if hex_code:
                bin_code = hex_to_bin(hex_code)
                assembly_code = bin_to_assembly(bin_code)+';'
                outfile.write(assembly_code + '\n')

# Example usage
file_name = 'test'
convert_hex_file_to_assembly(file_name)
