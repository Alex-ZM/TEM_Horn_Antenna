import skrf as rf
import matplotlib.pyplot as plt
import numpy as np
from scipy.fft import fft, fftfreq
from scipy.interpolate import interp1d

# Datos S11 experimentales
network1 = rf.Network('111111.s1p')
network2 = rf.Network('22222.s1p')

# Convierte S11 en VSWR para resultados experimentales
def s11_to_vswr(s11_complex):
    return (1 + np.abs(s11_complex)) / (1 - np.abs(s11_complex))

vswr1 = s11_to_vswr(network1.s[:, 0, 0])
frequencies_ghz1 = network1.f / 1e9

vswr2 = s11_to_vswr(network2.s[:, 0, 0])
frequencies_ghz2 = network2.f / 1e9

# Corriente y voltaje de la simulación
current_file_path = 'current.txt'
voltage_file_path = 'voltage.txt'
Z0 = 50.0

data_current = np.loadtxt(current_file_path)
time_current = data_current[:, 0]
current = data_current[:, 1]

data_voltage = np.loadtxt(voltage_file_path)
time_voltage = data_voltage[:, 0]
voltage = data_voltage[:, 1]

f_interp_voltage = interp1d(time_voltage, voltage, kind='linear', fill_value="extrapolate")
voltage_aligned = f_interp_voltage(time_current)
mask_extrapolate_to_zero = time_current > time_voltage.max()
voltage_aligned[mask_extrapolate_to_zero] = 0.0

dt = time_current[1] - time_current[0]
N = len(time_current)
V_f = fft(voltage_aligned)
I_f = fft(current)
frequencies_fourier = fftfreq(N, dt)

positive_freq_indices = frequencies_fourier >= 0
frequencies_ghz_fourier = frequencies_fourier[positive_freq_indices] / 1e9
V_f_pos = V_f[positive_freq_indices]
I_f_pos = I_f[positive_freq_indices]

Zin_complex = np.zeros_like(V_f_pos, dtype=complex)
ZL_complex = np.zeros_like(V_f_pos, dtype=complex)
non_zero_current_f = np.abs(I_f_pos) > 1e-12
Zin_complex[non_zero_current_f] = V_f_pos[non_zero_current_f] / I_f_pos[non_zero_current_f]
ZL_complex[non_zero_current_f] = Zin_complex[non_zero_current_f] - 50

# Calcula S11 y VSWR
S11_complex_calculated = np.zeros_like(ZL_complex, dtype=complex)
non_zero_denominator = np.abs(ZL_complex + Z0) > 1e-12
S11_complex_calculated[non_zero_denominator] = (ZL_complex[non_zero_denominator] - Z0) / (ZL_complex[non_zero_denominator] + Z0)
vswr_simulated = s11_to_vswr(S11_complex_calculated)
valid_vswr_indices_calc = ~np.isnan(vswr_simulated) & ~np.isinf(vswr_simulated)

# Gráfica Combinada de VSWR
plt.figure(figsize=(10, 7))
plt.plot(frequencies_ghz1, vswr1, label='VSWR - Antena con soporte grueso', color='tan', linestyle='-')
plt.plot(frequencies_ghz2, vswr2, label='VSWR - Antena con soporte fino', color='olive', linestyle='-')
plt.plot(frequencies_ghz_fourier[valid_vswr_indices_calc], vswr_simulated[valid_vswr_indices_calc], 
         label='VSWR - Antena simulada', color='blue', linestyle='--')

plt.axhline(y=2, color='darkslategrey', linestyle='-', label='Umbral VSWR = 2:1 ($|S_{11}|$ ≈ -10 dB)')

plt.title('Relación de Onda Estacionaria (VSWR) vs. Frecuencia')
plt.xlabel('Frecuencia (GHz)')
plt.ylabel('VSWR')
plt.ylim(1, 8) 
plt.xlim(1, 8.5) 
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()