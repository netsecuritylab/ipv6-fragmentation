MARKER_A = '11223344'
MARKER_B = '11332244'
MARKER_C = '22113344'
MARKER_D = '22331144'
MARKER_E = '33112244'
MARKER_F = '33221144'
MARKER_G = '44112233'

MARKER_AR = '44113322'
MARKER_BR = '44331122'
MARKER_CR = '44332211'
MARKER_DR = '11224433'
MARKER_ER = '11334422'
MARKER_FR = '22114433'
MARKER_GR = '22334411'

class bcolors:
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    GRAY = '\033[90m'

    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    RESET = '\033[0m'

def colorize_payload(payload):
    output_string = ""
    i = 0

    while i < len(payload):
        chunk = payload[i:i + 8]

        if chunk == "ICMPICMP":
            output_string += bcolors.GRAY+chunk
        elif chunk == MARKER_A or chunk == MARKER_AR:
            output_string += bcolors.YELLOW+chunk
        elif chunk == MARKER_B or chunk == MARKER_BR:
            output_string += bcolors.BLUE+chunk
        elif chunk == MARKER_C or chunk == MARKER_CR:
            output_string += bcolors.MAGENTA+chunk
        elif chunk == MARKER_D or chunk == MARKER_DR:
            output_string += bcolors.GREEN+chunk
        elif chunk == MARKER_E or chunk == MARKER_ER:
            output_string += bcolors.RED+chunk
        elif chunk == MARKER_F or chunk == MARKER_FR:
            output_string += bcolors.CYAN+chunk
        elif chunk == MARKER_G or chunk == MARKER_GR:
            output_string += bcolors.RESET+chunk
        else:
            output_string += chunk

        i += 8

    return output_string + bcolors.RESET
